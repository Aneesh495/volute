/*
 * State and Regional Tax Jurisdiction Calculation Engine
 *
 * Models base rates, average local surcharges, clothing exemptions,
 * and digital services tax nexus rules across jurisdictions.
 */

// Return jurisdiction tax configuration
fn get_state_tax_profile(state_code) {
    let profiles = #{};
    profiles["AL"] = #{ code: "AL", name: "Alabama", base_rate: 0.04, avg_local: 0.0525, clothing_exempt: false, digital_taxable: false };
    profiles["AK"] = #{ code: "AK", name: "Alaska", base_rate: 0.0, avg_local: 0.0176, clothing_exempt: false, digital_taxable: false };
    profiles["AZ"] = #{ code: "AZ", name: "Arizona", base_rate: 0.056, avg_local: 0.028, clothing_exempt: false, digital_taxable: false };
    profiles["AR"] = #{ code: "AR", name: "Arkansas", base_rate: 0.065, avg_local: 0.0297, clothing_exempt: false, digital_taxable: false };
    profiles["CA"] = #{ code: "CA", name: "California", base_rate: 0.0725, avg_local: 0.0157, clothing_exempt: true, digital_taxable: true };
    profiles["CO"] = #{ code: "CO", name: "Colorado", base_rate: 0.029, avg_local: 0.0487, clothing_exempt: false, digital_taxable: false };
    profiles["CT"] = #{ code: "CT", name: "Connecticut", base_rate: 0.0635, avg_local: 0.0, clothing_exempt: false, digital_taxable: true };
    profiles["DE"] = #{ code: "DE", name: "Delaware", base_rate: 0.0, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["FL"] = #{ code: "FL", name: "Florida", base_rate: 0.06, avg_local: 0.0102, clothing_exempt: false, digital_taxable: false };
    profiles["GA"] = #{ code: "GA", name: "Georgia", base_rate: 0.04, avg_local: 0.0335, clothing_exempt: false, digital_taxable: false };
    profiles["HI"] = #{ code: "HI", name: "Hawaii", base_rate: 0.04, avg_local: 0.0044, clothing_exempt: false, digital_taxable: false };
    profiles["ID"] = #{ code: "ID", name: "Idaho", base_rate: 0.06, avg_local: 0.0003, clothing_exempt: false, digital_taxable: false };
    profiles["IL"] = #{ code: "IL", name: "Illinois", base_rate: 0.0625, avg_local: 0.0256, clothing_exempt: false, digital_taxable: true };
    profiles["IN"] = #{ code: "IN", name: "Indiana", base_rate: 0.07, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["IA"] = #{ code: "IA", name: "Iowa", base_rate: 0.06, avg_local: 0.0094, clothing_exempt: false, digital_taxable: false };
    profiles["KS"] = #{ code: "KS", name: "Kansas", base_rate: 0.065, avg_local: 0.0217, clothing_exempt: false, digital_taxable: false };
    profiles["KY"] = #{ code: "KY", name: "Kentucky", base_rate: 0.06, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["LA"] = #{ code: "LA", name: "Louisiana", base_rate: 0.0445, avg_local: 0.051, clothing_exempt: false, digital_taxable: false };
    profiles["ME"] = #{ code: "ME", name: "Maine", base_rate: 0.055, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["MD"] = #{ code: "MD", name: "Maryland", base_rate: 0.06, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["MA"] = #{ code: "MA", name: "Massachusetts", base_rate: 0.0625, avg_local: 0.0, clothing_exempt: true, digital_taxable: true };
    profiles["MI"] = #{ code: "MI", name: "Michigan", base_rate: 0.06, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["MN"] = #{ code: "MN", name: "Minnesota", base_rate: 0.0688, avg_local: 0.0061, clothing_exempt: true, digital_taxable: true };
    profiles["MS"] = #{ code: "MS", name: "Mississippi", base_rate: 0.07, avg_local: 0.0007, clothing_exempt: false, digital_taxable: false };
    profiles["MO"] = #{ code: "MO", name: "Missouri", base_rate: 0.0423, avg_local: 0.0406, clothing_exempt: false, digital_taxable: false };
    profiles["MT"] = #{ code: "MT", name: "Montana", base_rate: 0.0, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["NE"] = #{ code: "NE", name: "Nebraska", base_rate: 0.055, avg_local: 0.0144, clothing_exempt: false, digital_taxable: false };
    profiles["NV"] = #{ code: "NV", name: "Nevada", base_rate: 0.0685, avg_local: 0.0138, clothing_exempt: false, digital_taxable: false };
    profiles["NH"] = #{ code: "NH", name: "New Hampshire", base_rate: 0.0, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["NJ"] = #{ code: "NJ", name: "New Jersey", base_rate: 0.0663, avg_local: -0.0003, clothing_exempt: true, digital_taxable: true };
    profiles["NM"] = #{ code: "NM", name: "New Mexico", base_rate: 0.0513, avg_local: 0.027, clothing_exempt: false, digital_taxable: false };
    profiles["NY"] = #{ code: "NY", name: "New York", base_rate: 0.04, avg_local: 0.0452, clothing_exempt: true, digital_taxable: true };
    profiles["NC"] = #{ code: "NC", name: "North Carolina", base_rate: 0.0475, avg_local: 0.0224, clothing_exempt: false, digital_taxable: false };
    profiles["ND"] = #{ code: "ND", name: "North Dakota", base_rate: 0.05, avg_local: 0.0196, clothing_exempt: false, digital_taxable: false };
    profiles["OH"] = #{ code: "OH", name: "Ohio", base_rate: 0.0575, avg_local: 0.0149, clothing_exempt: false, digital_taxable: false };
    profiles["OK"] = #{ code: "OK", name: "Oklahoma", base_rate: 0.045, avg_local: 0.0447, clothing_exempt: false, digital_taxable: false };
    profiles["OR"] = #{ code: "OR", name: "Oregon", base_rate: 0.0, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
    profiles["PA"] = #{ code: "PA", name: "Pennsylvania", base_rate: 0.06, avg_local: 0.0034, clothing_exempt: true, digital_taxable: true };
    profiles["RI"] = #{ code: "RI", name: "Rhode Island", base_rate: 0.07, avg_local: 0.0, clothing_exempt: true, digital_taxable: true };
    profiles["SC"] = #{ code: "SC", name: "South Carolina", base_rate: 0.06, avg_local: 0.0144, clothing_exempt: false, digital_taxable: false };
    profiles["SD"] = #{ code: "SD", name: "South Dakota", base_rate: 0.045, avg_local: 0.019, clothing_exempt: false, digital_taxable: false };
    profiles["TN"] = #{ code: "TN", name: "Tennessee", base_rate: 0.07, avg_local: 0.0255, clothing_exempt: false, digital_taxable: false };
    profiles["TX"] = #{ code: "TX", name: "Texas", base_rate: 0.0625, avg_local: 0.0195, clothing_exempt: false, digital_taxable: true };
    profiles["UT"] = #{ code: "UT", name: "Utah", base_rate: 0.061, avg_local: 0.0109, clothing_exempt: false, digital_taxable: false };
    profiles["VT"] = #{ code: "VT", name: "Vermont", base_rate: 0.06, avg_local: 0.0024, clothing_exempt: true, digital_taxable: true };
    profiles["VA"] = #{ code: "VA", name: "Virginia", base_rate: 0.053, avg_local: 0.0045, clothing_exempt: false, digital_taxable: false };
    profiles["WA"] = #{ code: "WA", name: "Washington", base_rate: 0.065, avg_local: 0.0279, clothing_exempt: false, digital_taxable: true };
    profiles["WV"] = #{ code: "WV", name: "West Virginia", base_rate: 0.06, avg_local: 0.0055, clothing_exempt: false, digital_taxable: false };
    profiles["WI"] = #{ code: "WI", name: "Wisconsin", base_rate: 0.05, avg_local: 0.0043, clothing_exempt: false, digital_taxable: false };
    profiles["WY"] = #{ code: "WY", name: "Wyoming", base_rate: 0.04, avg_local: 0.0136, clothing_exempt: false, digital_taxable: false };
    if profiles.contains(state_code) {
        return profiles[state_code];
    }
    return #{ code: state_code, name: "Unknown", base_rate: 0.0, avg_local: 0.0, clothing_exempt: false, digital_taxable: false };
}

// Calculate order sales tax given line items
fn calculate_order_tax(state_code, line_items, apply_local) {
    let profile = get_state_tax_profile(state_code);
    let rate = profile.base_rate;
    if apply_local {
        rate += profile.avg_local;
    }

    let total_tax = 0.0;
    for item in line_items {
        let price = item.price * 1.0;
        let qty = item.quantity * 1.0;
        let item_total = price * qty;
        let is_exempt = false;

        if item.category == "clothing" && profile.clothing_exempt {
            is_exempt = true;
        }
        if item.category == "digital" && !profile.digital_taxable {
            is_exempt = true;
        }

        if !is_exempt {
            total_tax += item_total * rate;
        }
    }

    let cents = (total_tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}
// Alabama (AL) Tax Rate and Exemption Helper
fn get_tax_rate_al() {
    return 0.04;
}
fn is_clothing_exempt_al() {
    return false;
}
fn is_digital_taxable_al() {
    return false;
}
fn compute_tax_al(amount) {
    let tax = (amount * 1.0) * 0.04;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Alaska (AK) Tax Rate and Exemption Helper
fn get_tax_rate_ak() {
    return 0.0;
}
fn is_clothing_exempt_ak() {
    return false;
}
fn is_digital_taxable_ak() {
    return false;
}
fn compute_tax_ak(amount) {
    let tax = (amount * 1.0) * 0.0;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Arizona (AZ) Tax Rate and Exemption Helper
fn get_tax_rate_az() {
    return 0.056;
}
fn is_clothing_exempt_az() {
    return false;
}
fn is_digital_taxable_az() {
    return false;
}
fn compute_tax_az(amount) {
    let tax = (amount * 1.0) * 0.056;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Arkansas (AR) Tax Rate and Exemption Helper
fn get_tax_rate_ar() {
    return 0.065;
}
fn is_clothing_exempt_ar() {
    return false;
}
fn is_digital_taxable_ar() {
    return false;
}
fn compute_tax_ar(amount) {
    let tax = (amount * 1.0) * 0.065;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// California (CA) Tax Rate and Exemption Helper
fn get_tax_rate_ca() {
    return 0.0725;
}
fn is_clothing_exempt_ca() {
    return true;
}
fn is_digital_taxable_ca() {
    return true;
}
fn compute_tax_ca(amount) {
    let tax = (amount * 1.0) * 0.0725;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Colorado (CO) Tax Rate and Exemption Helper
fn get_tax_rate_co() {
    return 0.029;
}
fn is_clothing_exempt_co() {
    return false;
}
fn is_digital_taxable_co() {
    return false;
}
fn compute_tax_co(amount) {
    let tax = (amount * 1.0) * 0.029;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Connecticut (CT) Tax Rate and Exemption Helper
fn get_tax_rate_ct() {
    return 0.0635;
}
fn is_clothing_exempt_ct() {
    return false;
}
fn is_digital_taxable_ct() {
    return true;
}
fn compute_tax_ct(amount) {
    let tax = (amount * 1.0) * 0.0635;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Delaware (DE) Tax Rate and Exemption Helper
fn get_tax_rate_de() {
    return 0.0;
}
fn is_clothing_exempt_de() {
    return false;
}
fn is_digital_taxable_de() {
    return false;
}
fn compute_tax_de(amount) {
    let tax = (amount * 1.0) * 0.0;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Florida (FL) Tax Rate and Exemption Helper
fn get_tax_rate_fl() {
    return 0.06;
}
fn is_clothing_exempt_fl() {
    return false;
}
fn is_digital_taxable_fl() {
    return false;
}
fn compute_tax_fl(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Georgia (GA) Tax Rate and Exemption Helper
fn get_tax_rate_ga() {
    return 0.04;
}
fn is_clothing_exempt_ga() {
    return false;
}
fn is_digital_taxable_ga() {
    return false;
}
fn compute_tax_ga(amount) {
    let tax = (amount * 1.0) * 0.04;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Hawaii (HI) Tax Rate and Exemption Helper
fn get_tax_rate_hi() {
    return 0.04;
}
fn is_clothing_exempt_hi() {
    return false;
}
fn is_digital_taxable_hi() {
    return false;
}
fn compute_tax_hi(amount) {
    let tax = (amount * 1.0) * 0.04;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Idaho (ID) Tax Rate and Exemption Helper
fn get_tax_rate_id() {
    return 0.06;
}
fn is_clothing_exempt_id() {
    return false;
}
fn is_digital_taxable_id() {
    return false;
}
fn compute_tax_id(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Illinois (IL) Tax Rate and Exemption Helper
fn get_tax_rate_il() {
    return 0.0625;
}
fn is_clothing_exempt_il() {
    return false;
}
fn is_digital_taxable_il() {
    return true;
}
fn compute_tax_il(amount) {
    let tax = (amount * 1.0) * 0.0625;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Indiana (IN) Tax Rate and Exemption Helper
fn get_tax_rate_in() {
    return 0.07;
}
fn is_clothing_exempt_in() {
    return false;
}
fn is_digital_taxable_in() {
    return false;
}
fn compute_tax_in(amount) {
    let tax = (amount * 1.0) * 0.07;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Iowa (IA) Tax Rate and Exemption Helper
fn get_tax_rate_ia() {
    return 0.06;
}
fn is_clothing_exempt_ia() {
    return false;
}
fn is_digital_taxable_ia() {
    return false;
}
fn compute_tax_ia(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Kansas (KS) Tax Rate and Exemption Helper
fn get_tax_rate_ks() {
    return 0.065;
}
fn is_clothing_exempt_ks() {
    return false;
}
fn is_digital_taxable_ks() {
    return false;
}
fn compute_tax_ks(amount) {
    let tax = (amount * 1.0) * 0.065;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Kentucky (KY) Tax Rate and Exemption Helper
fn get_tax_rate_ky() {
    return 0.06;
}
fn is_clothing_exempt_ky() {
    return false;
}
fn is_digital_taxable_ky() {
    return false;
}
fn compute_tax_ky(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Louisiana (LA) Tax Rate and Exemption Helper
fn get_tax_rate_la() {
    return 0.0445;
}
fn is_clothing_exempt_la() {
    return false;
}
fn is_digital_taxable_la() {
    return false;
}
fn compute_tax_la(amount) {
    let tax = (amount * 1.0) * 0.0445;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Maine (ME) Tax Rate and Exemption Helper
fn get_tax_rate_me() {
    return 0.055;
}
fn is_clothing_exempt_me() {
    return false;
}
fn is_digital_taxable_me() {
    return false;
}
fn compute_tax_me(amount) {
    let tax = (amount * 1.0) * 0.055;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Maryland (MD) Tax Rate and Exemption Helper
fn get_tax_rate_md() {
    return 0.06;
}
fn is_clothing_exempt_md() {
    return false;
}
fn is_digital_taxable_md() {
    return false;
}
fn compute_tax_md(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Massachusetts (MA) Tax Rate and Exemption Helper
fn get_tax_rate_ma() {
    return 0.0625;
}
fn is_clothing_exempt_ma() {
    return true;
}
fn is_digital_taxable_ma() {
    return true;
}
fn compute_tax_ma(amount) {
    let tax = (amount * 1.0) * 0.0625;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Michigan (MI) Tax Rate and Exemption Helper
fn get_tax_rate_mi() {
    return 0.06;
}
fn is_clothing_exempt_mi() {
    return false;
}
fn is_digital_taxable_mi() {
    return false;
}
fn compute_tax_mi(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Minnesota (MN) Tax Rate and Exemption Helper
fn get_tax_rate_mn() {
    return 0.0688;
}
fn is_clothing_exempt_mn() {
    return true;
}
fn is_digital_taxable_mn() {
    return true;
}
fn compute_tax_mn(amount) {
    let tax = (amount * 1.0) * 0.0688;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Mississippi (MS) Tax Rate and Exemption Helper
fn get_tax_rate_ms() {
    return 0.07;
}
fn is_clothing_exempt_ms() {
    return false;
}
fn is_digital_taxable_ms() {
    return false;
}
fn compute_tax_ms(amount) {
    let tax = (amount * 1.0) * 0.07;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Missouri (MO) Tax Rate and Exemption Helper
fn get_tax_rate_mo() {
    return 0.0423;
}
fn is_clothing_exempt_mo() {
    return false;
}
fn is_digital_taxable_mo() {
    return false;
}
fn compute_tax_mo(amount) {
    let tax = (amount * 1.0) * 0.0423;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Montana (MT) Tax Rate and Exemption Helper
fn get_tax_rate_mt() {
    return 0.0;
}
fn is_clothing_exempt_mt() {
    return false;
}
fn is_digital_taxable_mt() {
    return false;
}
fn compute_tax_mt(amount) {
    let tax = (amount * 1.0) * 0.0;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Nebraska (NE) Tax Rate and Exemption Helper
fn get_tax_rate_ne() {
    return 0.055;
}
fn is_clothing_exempt_ne() {
    return false;
}
fn is_digital_taxable_ne() {
    return false;
}
fn compute_tax_ne(amount) {
    let tax = (amount * 1.0) * 0.055;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Nevada (NV) Tax Rate and Exemption Helper
fn get_tax_rate_nv() {
    return 0.0685;
}
fn is_clothing_exempt_nv() {
    return false;
}
fn is_digital_taxable_nv() {
    return false;
}
fn compute_tax_nv(amount) {
    let tax = (amount * 1.0) * 0.0685;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// New Hampshire (NH) Tax Rate and Exemption Helper
fn get_tax_rate_nh() {
    return 0.0;
}
fn is_clothing_exempt_nh() {
    return false;
}
fn is_digital_taxable_nh() {
    return false;
}
fn compute_tax_nh(amount) {
    let tax = (amount * 1.0) * 0.0;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// New Jersey (NJ) Tax Rate and Exemption Helper
fn get_tax_rate_nj() {
    return 0.0663;
}
fn is_clothing_exempt_nj() {
    return true;
}
fn is_digital_taxable_nj() {
    return true;
}
fn compute_tax_nj(amount) {
    let tax = (amount * 1.0) * 0.0663;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// New Mexico (NM) Tax Rate and Exemption Helper
fn get_tax_rate_nm() {
    return 0.0513;
}
fn is_clothing_exempt_nm() {
    return false;
}
fn is_digital_taxable_nm() {
    return false;
}
fn compute_tax_nm(amount) {
    let tax = (amount * 1.0) * 0.0513;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// New York (NY) Tax Rate and Exemption Helper
fn get_tax_rate_ny() {
    return 0.04;
}
fn is_clothing_exempt_ny() {
    return true;
}
fn is_digital_taxable_ny() {
    return true;
}
fn compute_tax_ny(amount) {
    let tax = (amount * 1.0) * 0.04;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// North Carolina (NC) Tax Rate and Exemption Helper
fn get_tax_rate_nc() {
    return 0.0475;
}
fn is_clothing_exempt_nc() {
    return false;
}
fn is_digital_taxable_nc() {
    return false;
}
fn compute_tax_nc(amount) {
    let tax = (amount * 1.0) * 0.0475;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// North Dakota (ND) Tax Rate and Exemption Helper
fn get_tax_rate_nd() {
    return 0.05;
}
fn is_clothing_exempt_nd() {
    return false;
}
fn is_digital_taxable_nd() {
    return false;
}
fn compute_tax_nd(amount) {
    let tax = (amount * 1.0) * 0.05;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Ohio (OH) Tax Rate and Exemption Helper
fn get_tax_rate_oh() {
    return 0.0575;
}
fn is_clothing_exempt_oh() {
    return false;
}
fn is_digital_taxable_oh() {
    return false;
}
fn compute_tax_oh(amount) {
    let tax = (amount * 1.0) * 0.0575;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Oklahoma (OK) Tax Rate and Exemption Helper
fn get_tax_rate_ok() {
    return 0.045;
}
fn is_clothing_exempt_ok() {
    return false;
}
fn is_digital_taxable_ok() {
    return false;
}
fn compute_tax_ok(amount) {
    let tax = (amount * 1.0) * 0.045;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Oregon (OR) Tax Rate and Exemption Helper
fn get_tax_rate_or() {
    return 0.0;
}
fn is_clothing_exempt_or() {
    return false;
}
fn is_digital_taxable_or() {
    return false;
}
fn compute_tax_or(amount) {
    let tax = (amount * 1.0) * 0.0;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Pennsylvania (PA) Tax Rate and Exemption Helper
fn get_tax_rate_pa() {
    return 0.06;
}
fn is_clothing_exempt_pa() {
    return true;
}
fn is_digital_taxable_pa() {
    return true;
}
fn compute_tax_pa(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Rhode Island (RI) Tax Rate and Exemption Helper
fn get_tax_rate_ri() {
    return 0.07;
}
fn is_clothing_exempt_ri() {
    return true;
}
fn is_digital_taxable_ri() {
    return true;
}
fn compute_tax_ri(amount) {
    let tax = (amount * 1.0) * 0.07;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// South Carolina (SC) Tax Rate and Exemption Helper
fn get_tax_rate_sc() {
    return 0.06;
}
fn is_clothing_exempt_sc() {
    return false;
}
fn is_digital_taxable_sc() {
    return false;
}
fn compute_tax_sc(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// South Dakota (SD) Tax Rate and Exemption Helper
fn get_tax_rate_sd() {
    return 0.045;
}
fn is_clothing_exempt_sd() {
    return false;
}
fn is_digital_taxable_sd() {
    return false;
}
fn compute_tax_sd(amount) {
    let tax = (amount * 1.0) * 0.045;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Tennessee (TN) Tax Rate and Exemption Helper
fn get_tax_rate_tn() {
    return 0.07;
}
fn is_clothing_exempt_tn() {
    return false;
}
fn is_digital_taxable_tn() {
    return false;
}
fn compute_tax_tn(amount) {
    let tax = (amount * 1.0) * 0.07;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Texas (TX) Tax Rate and Exemption Helper
fn get_tax_rate_tx() {
    return 0.0625;
}
fn is_clothing_exempt_tx() {
    return false;
}
fn is_digital_taxable_tx() {
    return true;
}
fn compute_tax_tx(amount) {
    let tax = (amount * 1.0) * 0.0625;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Utah (UT) Tax Rate and Exemption Helper
fn get_tax_rate_ut() {
    return 0.061;
}
fn is_clothing_exempt_ut() {
    return false;
}
fn is_digital_taxable_ut() {
    return false;
}
fn compute_tax_ut(amount) {
    let tax = (amount * 1.0) * 0.061;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Vermont (VT) Tax Rate and Exemption Helper
fn get_tax_rate_vt() {
    return 0.06;
}
fn is_clothing_exempt_vt() {
    return true;
}
fn is_digital_taxable_vt() {
    return true;
}
fn compute_tax_vt(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Virginia (VA) Tax Rate and Exemption Helper
fn get_tax_rate_va() {
    return 0.053;
}
fn is_clothing_exempt_va() {
    return false;
}
fn is_digital_taxable_va() {
    return false;
}
fn compute_tax_va(amount) {
    let tax = (amount * 1.0) * 0.053;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Washington (WA) Tax Rate and Exemption Helper
fn get_tax_rate_wa() {
    return 0.065;
}
fn is_clothing_exempt_wa() {
    return false;
}
fn is_digital_taxable_wa() {
    return true;
}
fn compute_tax_wa(amount) {
    let tax = (amount * 1.0) * 0.065;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// West Virginia (WV) Tax Rate and Exemption Helper
fn get_tax_rate_wv() {
    return 0.06;
}
fn is_clothing_exempt_wv() {
    return false;
}
fn is_digital_taxable_wv() {
    return false;
}
fn compute_tax_wv(amount) {
    let tax = (amount * 1.0) * 0.06;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Wisconsin (WI) Tax Rate and Exemption Helper
fn get_tax_rate_wi() {
    return 0.05;
}
fn is_clothing_exempt_wi() {
    return false;
}
fn is_digital_taxable_wi() {
    return false;
}
fn compute_tax_wi(amount) {
    let tax = (amount * 1.0) * 0.05;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}

// Wyoming (WY) Tax Rate and Exemption Helper
fn get_tax_rate_wy() {
    return 0.04;
}
fn is_clothing_exempt_wy() {
    return false;
}
fn is_digital_taxable_wy() {
    return false;
}
fn compute_tax_wy(amount) {
    let tax = (amount * 1.0) * 0.04;
    let cents = (tax * 100.0 + 0.5).to_int();
    return (cents * 1.0) / 100.0;
}
