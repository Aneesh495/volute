/*
 * MQTT Topic Hierarchy Matcher with Wildcards
 *
 * Supports multi-level '#' and single-level '+' MQTT wildcard subscriptions.
 */

import "lib/core/strings" as str_mod;

// Check if subscribed filter matches published topic
fn mqtt_topic_matches(subscription, topic) {
    if subscription == "#" {
        return true;
    }
    if subscription == topic {
        return true;
    }

    let sub_parts = str_mod::split_char(subscription, "/");
    let topic_parts = str_mod::split_char(topic, "/");

    let i = 0;
    while i < sub_parts.len() {
        let sub_token = sub_parts[i];

        if sub_token == "#" {
            // Multi-level wildcard must be last token
            return i == sub_parts.len() - 1;
        }

        if i >= topic_parts.len() {
            return false;
        }

        let topic_token = topic_parts[i];
        if sub_token != "+" && sub_token != topic_token {
            return false;
        }

        i += 1;
    }

    return i == topic_parts.len();
}
