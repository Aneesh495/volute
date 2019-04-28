/*
 * Dynamic Surge Pricing and Elasticity Engine
 *
 * Computes price surge multiplier based on localized demand vs supply capacity.
 */

// Calculate dynamic surge pricing multiplier in range [1.0, 3.5]
fn calculate_surge_multiplier(demand_orders, supply_capacity, price_elasticity) {
    if supply_capacity <= 0 {
        return 3.0; // maximum surge during zero supply
    }

    let ratio = (demand_orders * 1.0) / (supply_capacity * 1.0);
    if ratio <= 1.0 {
        return 1.0; // normal pricing
    }

    let excess_demand = ratio - 1.0;
    let multiplier = 1.0 + excess_demand * (price_elasticity * 1.0);

    // Clamp multiplier to [1.0, 3.5]
    if multiplier > 3.5 {
        return 3.5;
    }
    return multiplier;
}

// Apply surge multiplier to base order fare
fn apply_surge(base_fare, surge_multiplier) {
    let fare = (base_fare * 1.0) * surge_multiplier;
    // Round to 2 decimal places
    let cents = (fare * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}
