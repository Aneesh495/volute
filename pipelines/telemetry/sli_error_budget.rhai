/*
 * Service Level Objective (SLO) Error Budget Burn Rate Calculator
 *
 * Implements multi-window burn rate alert calculation per Google SRE book.
 */

fn calculate_burn_rate(total_requests, failed_requests, slo_target) {
    if total_requests == 0 {
        return 0.0;
    }
    let error_rate = (failed_requests * 1.0) / (total_requests * 1.0);
    let error_budget = 1.0 - slo_target;
    if error_budget <= 0.0 {
        return 100.0;
    }
    return error_rate / error_budget;
}

fn evaluate_slo_alert(burn_rate, window_hours) {
    // 1-hour window with burn rate > 14.4 consumes 2% of budget in 1 hour
    if window_hours == 1 && burn_rate > 14.4 {
        return #{ alert: "PAGE", message: "Fast burn rate: 2% budget consumed in 1 hour" };
    }
    // 6-hour window with burn rate > 6.0 consumes 5% of budget in 6 hours
    if window_hours == 6 && burn_rate > 6.0 {
        return #{ alert: "PAGE", message: "Fast burn rate: 5% budget consumed in 6 hours" };
    }
    return #{ alert: "NONE", message: "Budget healthy" };
}
