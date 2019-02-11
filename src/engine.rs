use rhai::{Engine, Scope, AST, EvalAltResult, ParseError};
use std::sync::Arc;
use std::path::Path;
use parking_lot::RwLock;
use std::collections::HashMap;

pub struct VoluteEngine {
    engine: Engine,
    ast_cache: Arc<RwLock<HashMap<String, AST>>>,
}

impl Default for VoluteEngine {
    fn default() -> Self {
        Self::new()
    }
}

impl VoluteEngine {
    pub fn new() -> Self {
        let mut engine = Engine::new();
        engine.set_max_operations(500_000);
        engine.set_max_call_levels(64);
        engine.set_max_string_size(1_000_000);
        engine.set_max_array_size(100_000);
        engine.set_max_map_size(100_000);
        engine.set_max_expr_depths(256, 256);

        crate::packages::register_all(&mut engine);

        Self {
            engine,
            ast_cache: Arc::new(RwLock::new(HashMap::new())),
        }
    }

    pub fn compile_file<P: AsRef<Path>>(&self, path: P) -> Result<AST, Box<EvalAltResult>> {
        let p = path.as_ref();
        let key = p.to_string_lossy().to_string();
        {
            let cache = self.ast_cache.read();
            if let Some(ast) = cache.get(&key) {
                return Ok(ast.clone());
            }
        }

        let ast = self.engine.compile_file(p.to_path_buf())?;
        let mut cache = self.ast_cache.write();
        cache.insert(key, ast.clone());
        Ok(ast)
    }

    pub fn compile_script(&self, script: &str) -> Result<AST, ParseError> {
        self.engine.compile(script)
    }

    pub fn eval<T: Clone + Send + Sync + 'static>(&self, script: &str) -> Result<T, Box<EvalAltResult>> {
        self.engine.eval(script)
    }

    pub fn eval_ast_with_scope<T: Clone + Send + Sync + 'static>(
        &self,
        scope: &mut Scope,
        ast: &AST,
    ) -> Result<T, Box<EvalAltResult>> {
        self.engine.eval_ast_with_scope(scope, ast)
    }

    pub fn call_fn<T: Clone + Send + Sync + 'static>(
        &self,
        scope: &mut Scope,
        ast: &AST,
        name: &str,
        args: impl rhai::FuncArgs,
    ) -> Result<T, Box<EvalAltResult>> {
        self.engine.call_fn(scope, ast, name, args)
    }

    pub fn raw_engine(&self) -> &Engine {
        &self.engine
    }

    pub fn raw_engine_mut(&mut self) -> &mut Engine {
        &mut self.engine
    }
}
