use clap::{Parser, Subcommand};
use std::path::PathBuf;
use std::time::Instant;
use crate::engine::VoluteEngine;
use crate::pipeline::{PipelineManifest, PipelineRunner};

#[derive(Parser)]
#[command(name = "volute")]
#[command(about = "High-throughput stream processing and reactive rule fabric driven by embedded Rhai", long_about = None)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Check syntax and compile AST of Rhai scripts
    Check {
        /// Path to Rhai script file
        file: PathBuf,
    },
    /// Evaluate a Rhai expression
    Eval {
        /// Rhai expression or code block
        expr: String,
    },
    /// Run a pipeline manifest
    Run {
        /// Path to YAML or JSON manifest
        manifest: PathBuf,
    },
    /// Run Rhai test suites
    Test {
        /// Test directory or script file
        #[arg(default_value = "tests")]
        path: PathBuf,
    },
    /// Microbenchmark a Rhai script
    Bench {
        /// Path to Rhai script file
        file: PathBuf,
        /// Number of iterations
        #[arg(short, long, default_value_t = 100_000)]
        iterations: usize,
    },
}

pub fn run() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();
    let engine = VoluteEngine::new();

    match cli.command {
        Commands::Check { file } => {
            let start = Instant::now();
            match engine.compile_file(&file) {
                Ok(_) => {
                    println!("OK: {} compiled successfully in {:?}", file.display(), start.elapsed());
                }
                Err(err) => {
                    eprintln!("ERROR: Failed to compile {}: {}", file.display(), err);
                    std::process::exit(1);
                }
            }
        }
        Commands::Eval { expr } => {
            match engine.eval::<rhai::Dynamic>(&expr) {
                Ok(val) => {
                    println!("{}", val);
                }
                Err(err) => {
                    eprintln!("Evaluation error: {}", err);
                    std::process::exit(1);
                }
            }
        }
        Commands::Run { manifest } => {
            let content = std::fs::read_to_string(&manifest)?;
            let manifest_data = PipelineManifest::from_yaml(&content)?;
            let default_base = PathBuf::from("."); let base_dir = manifest.parent().unwrap_or(&default_base);
            let runner = PipelineRunner::from_manifest(&manifest_data, base_dir)
                .map_err(|e| format!("Pipeline error: {}", e))?;
            println!("Started pipeline '{}' with {} stages", runner.name, runner.stages.len());
        }
        Commands::Test { path } => {
            run_tests(&engine, &path)?;
        }
        Commands::Bench { file, iterations } => {
            run_bench(&engine, &file, iterations)?;
        }
    }
    Ok(())
}

fn run_tests(engine: &VoluteEngine, path: &PathBuf) -> Result<(), Box<dyn std::error::Error>> {
    let mut test_files = Vec::new();
    if path.is_file() {
        test_files.push(path.clone());
    } else if path.is_dir() {
        for entry in std::fs::read_dir(path)? {
            let entry = entry?;
            let p = entry.path();
            if p.extension().map_or(false, |ext| ext == "rhai") {
                test_files.push(p);
            }
        }
    }

    test_files.sort();
    let mut passed = 0;
    let mut failed = 0;

    println!("Running {} Rhai test suites...", test_files.len());
    for file in &test_files {
        print!("  test {} ... ", file.file_name().unwrap_or_default().to_string_lossy());
        let start = Instant::now();
        match engine.compile_file(file) {
            Ok(ast) => {
                let mut scope = rhai::Scope::new();
                match engine.eval_ast_with_scope::<rhai::Dynamic>(&mut scope, &ast) {
                    Ok(_) => {
                        println!("ok ({:?})", start.elapsed());
                        passed += 1;
                    }
                    Err(err) => {
                        println!("FAILED ({:?})", start.elapsed());
                        eprintln!("    {}", err);
                        failed += 1;
                    }
                }
            }
            Err(err) => {
                println!("COMPILE ERROR");
                eprintln!("    {}", err);
                failed += 1;
            }
        }
    }

    println!("\nTest result: {} passed, {} failed, {} total\n", passed, failed, test_files.len());
    if failed > 0 {
        std::process::exit(1);
    }
    Ok(())
}

fn run_bench(engine: &VoluteEngine, file: &PathBuf, iterations: usize) -> Result<(), Box<dyn std::error::Error>> {
    println!("Benchmarking {} over {} iterations...", file.display(), iterations);
    let ast = engine.compile_file(file)?;
    
    // Warmup
    for _ in 0..1000 {
        let mut scope = rhai::Scope::new();
        let _ = engine.eval_ast_with_scope::<rhai::Dynamic>(&mut scope, &ast);
    }

    let start = Instant::now();
    for _ in 0..iterations {
        let mut scope = rhai::Scope::new();
        let _ = engine.eval_ast_with_scope::<rhai::Dynamic>(&mut scope, &ast);
    }
    let elapsed = start.elapsed();
    let nanos_per_op = elapsed.as_nanos() as f64 / iterations as f64;
    let ops_per_sec = iterations as f64 / elapsed.as_secs_f64();

    println!("  Total time: {:?}", elapsed);
    println!("  Latency: {:.2} ns/op ({:.2} us/op)", nanos_per_op, nanos_per_op / 1000.0);
    println!("  Throughput: {:.2} ops/sec", ops_per_sec);
    Ok(())
}
