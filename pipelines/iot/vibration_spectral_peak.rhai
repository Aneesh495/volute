/*
 * Industrial Rotating Machinery Vibration Peak Analysis
 *
 * Analyzes vibration amplitude samples and detects bearing degradation.
 */

import "lib/stats/descriptive" as stats_mod;

fn evaluate_vibration(sensor_id, samples, crest_factor_threshold) {
    let mean_val = stats_mod::mean(samples);
    let s_dev = stats_mod::stddev(samples);

    let max_peak = 0.0;
    for x in samples {
        let abs_x = if x < 0.0 { -x } else { x * 1.0 };
        if abs_x > max_peak {
            max_peak = abs_x;
        }
    }

    if s_dev == 0.0 {
        return ();
    }

    let crest_factor = max_peak / s_dev;
    if crest_factor > crest_factor_threshold {
        return #{
            alert: "BEARING_WEAR_SUSPECTED",
            sensor_id: sensor_id,
            crest_factor: crest_factor,
            peak_g: max_peak,
            rms_g: s_dev,
            severity: "MEDIUM"
        };
    }
    return ();
}
