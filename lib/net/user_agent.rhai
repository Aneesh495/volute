/*
 * User-Agent Classification and Heuristics
 *
 * Identifies browsers, operating systems, bots, and device categories.
 */

// Classify device category: mobile, tablet, desktop, or bot
fn classify_device(ua) {
    let u = ua.to_lower();
    if u.contains("bot") || u.contains("crawler") || u.contains("spider") ||
       u.contains("curl") || u.contains("wget") || u.contains("python") {
        return "bot";
    }
    if u.contains("ipad") || u.contains("tablet") {
        return "tablet";
    }
    if u.contains("mobile") || u.contains("android") || u.contains("iphone") {
        return "mobile";
    }
    return "desktop";
}

// Extract primary browser family
fn detect_browser(ua) {
    let u = ua.to_lower();
    if u.contains("edg/") {
        return "Edge";
    }
    if u.contains("chrome/") && !u.contains("edg/") {
        return "Chrome";
    }
    if u.contains("firefox/") {
        return "Firefox";
    }
    if u.contains("safari/") && !u.contains("chrome/") {
        return "Safari";
    }
    if u.contains("opera/") || u.contains("opr/") {
        return "Opera";
    }
    return "Other";
}

// Extract primary operating system family
fn detect_os(ua) {
    let u = ua.to_lower();
    if u.contains("windows nt") {
        return "Windows";
    }
    if u.contains("macintosh") || u.contains("mac os x") {
        return "macOS";
    }
    if u.contains("iphone") || u.contains("ipad") {
        return "iOS";
    }
    if u.contains("android") {
        return "Android";
    }
    if u.contains("linux") {
        return "Linux";
    }
    return "Other";
}
