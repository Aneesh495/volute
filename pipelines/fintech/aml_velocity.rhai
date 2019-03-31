/*
 * Anti-Money Laundering (AML) Smurfing and Structuring Detector
 *
 * Detects multiple transactions structured below $10,000 threshold.
 */

fn init_aml_monitor(threshold_amount, max_transactions, window_ms) {
    return #{
        threshold: threshold_amount,
        max_tx: max_transactions,
        window_ms: window_ms,
        user_history: #{} // user_id -> [#{ amount, ts_ms }]
    };
}

fn process_transfer(monitor, event) {
    let user_id = event.payload["sender_id"];
    let amount = event.payload["amount"] * 1.0;
    let ts_ms = event.timestamp_ns / 1000000;

    if !monitor.user_history.contains(user_id) {
        monitor.user_history[user_id] = [];
    }

    let history = monitor.user_history[user_id];
    let recent = [];
    let sum_recent = 0.0;

    for tx in history {
        if ts_ms - tx.ts_ms <= monitor.window_ms {
            recent.push(tx);
            sum_recent += tx.amount;
        }
    }

    recent.push(#{ amount: amount, ts_ms: ts_ms });
    sum_recent += amount;
    monitor.user_history[user_id] = recent;

    // Detect structuring (smurfing): multiple sub-threshold transactions summing over limit
    if recent.len() >= monitor.max_tx && sum_recent >= monitor.threshold {
        return #{
            alert: "AML_STRUCTURING_SUSPECTED",
            user_id: user_id,
            transaction_count: recent.len(),
            cumulative_amount: sum_recent,
            window_minutes: monitor.window_ms / 60000,
            severity: "HIGH"
        };
    }
    return ();
}
