/*
 * Foreign Exchange (FX) Cross-Rates and Triangular Arbitrage Matrix
 *
 * Computes cross currency exchange rates, bid-ask spreads, and arbitrage cycles.
 */

// Return reference rate against USD base
fn get_usd_base_rate(currency_code) {
    let rates = #{};
    rates["USD"] = 1.0;
    rates["EUR"] = 1.085;
    rates["GBP"] = 1.265;
    rates["JPY"] = 0.0067;
    rates["CHF"] = 1.132;
    rates["AUD"] = 0.655;
    rates["CAD"] = 0.742;
    rates["NZD"] = 0.612;
    rates["CNY"] = 0.139;
    rates["HKD"] = 0.128;
    rates["SGD"] = 0.745;
    rates["SEK"] = 0.096;
    rates["NOK"] = 0.094;
    rates["KRW"] = 0.00075;
    rates["INR"] = 0.012;
    rates["BRL"] = 0.201;
    rates["ZAR"] = 0.053;
    rates["MXN"] = 0.058;
    rates["PLN"] = 0.252;
    rates["TRY"] = 0.031;
    if rates.contains(currency_code) {
        return rates[currency_code];
    }
    return 1.0;
}

// Compute cross exchange rate between base_curr and quote_curr
fn get_cross_rate(base_curr, quote_curr) {
    let r_base = get_usd_base_rate(base_curr);
    let r_quote = get_usd_base_rate(quote_curr);
    if r_quote <= 0.0 { return 0.0; }
    return r_base / r_quote;
}

// Detect triangular arbitrage opportunity between three currency pairs
fn check_triangular_arbitrage(c1, c2, c3, r12, r23, r31, transaction_fee_bps) {
    let product = (r12 * 1.0) * (r23 * 1.0) * (r31 * 1.0);
    let fee_multiplier = 1.0 - (3.0 * (transaction_fee_bps * 1.0) / 10000.0);
    let net_return = product * fee_multiplier;
    if net_return > 1.0 {
        let profit_pct = (net_return - 1.0) * 100.0;
        return #{
            has_arbitrage: true,
            cycle: [c1, c2, c3],
            net_multiplier: net_return,
            profit_percentage: profit_pct
        };
    }
    return #{ has_arbitrage: false, net_multiplier: net_return, profit_percentage: 0.0 };
}
// Cross Rate USD/EUR
fn rate_usd_eur() {
    return 0.9216589861751152;
}

// Cross Rate USD/GBP
fn rate_usd_gbp() {
    return 0.790513833992095;
}

// Cross Rate USD/JPY
fn rate_usd_jpy() {
    return 149.2537313432836;
}

// Cross Rate USD/CHF
fn rate_usd_chf() {
    return 0.88339222614841;
}

// Cross Rate USD/AUD
fn rate_usd_aud() {
    return 1.5267175572519083;
}

// Cross Rate USD/CAD
fn rate_usd_cad() {
    return 1.3477088948787062;
}

// Cross Rate USD/NZD
fn rate_usd_nzd() {
    return 1.6339869281045751;
}

// Cross Rate USD/CNY
fn rate_usd_cny() {
    return 7.194244604316546;
}

// Cross Rate USD/HKD
fn rate_usd_hkd() {
    return 7.8125;
}

// Cross Rate USD/SGD
fn rate_usd_sgd() {
    return 1.342281879194631;
}

// Cross Rate USD/SEK
fn rate_usd_sek() {
    return 10.416666666666666;
}

// Cross Rate USD/NOK
fn rate_usd_nok() {
    return 10.638297872340425;
}

// Cross Rate USD/KRW
fn rate_usd_krw() {
    return 1333.3333333333333;
}

// Cross Rate USD/INR
fn rate_usd_inr() {
    return 83.33333333333333;
}

// Cross Rate USD/BRL
fn rate_usd_brl() {
    return 4.975124378109452;
}

// Cross Rate USD/ZAR
fn rate_usd_zar() {
    return 18.867924528301888;
}

// Cross Rate USD/MXN
fn rate_usd_mxn() {
    return 17.241379310344826;
}

// Cross Rate USD/PLN
fn rate_usd_pln() {
    return 3.9682539682539684;
}

// Cross Rate USD/TRY
fn rate_usd_try() {
    return 32.25806451612903;
}

// Cross Rate EUR/USD
fn rate_eur_usd() {
    return 1.085;
}

// Cross Rate EUR/GBP
fn rate_eur_gbp() {
    return 0.857707509881423;
}

// Cross Rate EUR/JPY
fn rate_eur_jpy() {
    return 161.94029850746267;
}

// Cross Rate EUR/CHF
fn rate_eur_chf() {
    return 0.9584805653710248;
}

// Cross Rate EUR/AUD
fn rate_eur_aud() {
    return 1.6564885496183206;
}

// Cross Rate EUR/CAD
fn rate_eur_cad() {
    return 1.4622641509433962;
}

// Cross Rate EUR/NZD
fn rate_eur_nzd() {
    return 1.772875816993464;
}

// Cross Rate EUR/CNY
fn rate_eur_cny() {
    return 7.805755395683453;
}

// Cross Rate EUR/HKD
fn rate_eur_hkd() {
    return 8.4765625;
}

// Cross Rate EUR/SGD
fn rate_eur_sgd() {
    return 1.4563758389261745;
}

// Cross Rate EUR/SEK
fn rate_eur_sek() {
    return 11.302083333333332;
}

// Cross Rate EUR/NOK
fn rate_eur_nok() {
    return 11.542553191489361;
}

// Cross Rate EUR/KRW
fn rate_eur_krw() {
    return 1446.6666666666665;
}

// Cross Rate EUR/INR
fn rate_eur_inr() {
    return 90.41666666666666;
}

// Cross Rate EUR/BRL
fn rate_eur_brl() {
    return 5.398009950248755;
}

// Cross Rate EUR/ZAR
fn rate_eur_zar() {
    return 20.471698113207548;
}

// Cross Rate EUR/MXN
fn rate_eur_mxn() {
    return 18.706896551724135;
}

// Cross Rate EUR/PLN
fn rate_eur_pln() {
    return 4.305555555555555;
}

// Cross Rate EUR/TRY
fn rate_eur_try() {
    return 35.0;
}

// Cross Rate GBP/USD
fn rate_gbp_usd() {
    return 1.265;
}

// Cross Rate GBP/EUR
fn rate_gbp_eur() {
    return 1.1658986175115207;
}

// Cross Rate GBP/JPY
fn rate_gbp_jpy() {
    return 188.8059701492537;
}

// Cross Rate GBP/CHF
fn rate_gbp_chf() {
    return 1.1174911660777385;
}

// Cross Rate GBP/AUD
fn rate_gbp_aud() {
    return 1.931297709923664;
}

// Cross Rate GBP/CAD
fn rate_gbp_cad() {
    return 1.7048517520215631;
}

// Cross Rate GBP/NZD
fn rate_gbp_nzd() {
    return 2.0669934640522873;
}

// Cross Rate GBP/CNY
fn rate_gbp_cny() {
    return 9.10071942446043;
}

// Cross Rate GBP/HKD
fn rate_gbp_hkd() {
    return 9.882812499999998;
}

// Cross Rate GBP/SGD
fn rate_gbp_sgd() {
    return 1.697986577181208;
}

// Cross Rate GBP/SEK
fn rate_gbp_sek() {
    return 13.177083333333332;
}

// Cross Rate GBP/NOK
fn rate_gbp_nok() {
    return 13.457446808510637;
}

// Cross Rate GBP/KRW
fn rate_gbp_krw() {
    return 1686.6666666666665;
}

// Cross Rate GBP/INR
fn rate_gbp_inr() {
    return 105.41666666666666;
}

// Cross Rate GBP/BRL
fn rate_gbp_brl() {
    return 6.293532338308457;
}

// Cross Rate GBP/ZAR
fn rate_gbp_zar() {
    return 23.867924528301884;
}

// Cross Rate GBP/MXN
fn rate_gbp_mxn() {
    return 21.810344827586203;
}

// Cross Rate GBP/PLN
fn rate_gbp_pln() {
    return 5.01984126984127;
}

// Cross Rate GBP/TRY
fn rate_gbp_try() {
    return 40.806451612903224;
}

// Cross Rate JPY/USD
fn rate_jpy_usd() {
    return 0.0067;
}

// Cross Rate JPY/EUR
fn rate_jpy_eur() {
    return 0.006175115207373272;
}

// Cross Rate JPY/GBP
fn rate_jpy_gbp() {
    return 0.005296442687747037;
}

// Cross Rate JPY/CHF
fn rate_jpy_chf() {
    return 0.005918727915194347;
}

// Cross Rate JPY/AUD
fn rate_jpy_aud() {
    return 0.010229007633587786;
}

// Cross Rate JPY/CAD
fn rate_jpy_cad() {
    return 0.009029649595687332;
}

// Cross Rate JPY/NZD
fn rate_jpy_nzd() {
    return 0.010947712418300655;
}

// Cross Rate JPY/CNY
fn rate_jpy_cny() {
    return 0.04820143884892086;
}

// Cross Rate JPY/HKD
fn rate_jpy_hkd() {
    return 0.05234375;
}

// Cross Rate JPY/SGD
fn rate_jpy_sgd() {
    return 0.008993288590604028;
}

// Cross Rate JPY/SEK
fn rate_jpy_sek() {
    return 0.06979166666666667;
}

// Cross Rate JPY/NOK
fn rate_jpy_nok() {
    return 0.07127659574468086;
}

// Cross Rate JPY/KRW
fn rate_jpy_krw() {
    return 8.933333333333334;
}

// Cross Rate JPY/INR
fn rate_jpy_inr() {
    return 0.5583333333333333;
}

// Cross Rate JPY/BRL
fn rate_jpy_brl() {
    return 0.03333333333333333;
}

// Cross Rate JPY/ZAR
fn rate_jpy_zar() {
    return 0.12641509433962264;
}

// Cross Rate JPY/MXN
fn rate_jpy_mxn() {
    return 0.11551724137931034;
}

// Cross Rate JPY/PLN
fn rate_jpy_pln() {
    return 0.026587301587301587;
}

// Cross Rate JPY/TRY
fn rate_jpy_try() {
    return 0.2161290322580645;
}

// Cross Rate CHF/USD
fn rate_chf_usd() {
    return 1.132;
}

// Cross Rate CHF/EUR
fn rate_chf_eur() {
    return 1.0433179723502304;
}

// Cross Rate CHF/GBP
fn rate_chf_gbp() {
    return 0.8948616600790513;
}

// Cross Rate CHF/JPY
fn rate_chf_jpy() {
    return 168.955223880597;
}

// Cross Rate CHF/AUD
fn rate_chf_aud() {
    return 1.72824427480916;
}

// Cross Rate CHF/CAD
fn rate_chf_cad() {
    return 1.5256064690026954;
}

// Cross Rate CHF/NZD
fn rate_chf_nzd() {
    return 1.849673202614379;
}

// Cross Rate CHF/CNY
fn rate_chf_cny() {
    return 8.14388489208633;
}

// Cross Rate CHF/HKD
fn rate_chf_hkd() {
    return 8.843749999999998;
}

// Cross Rate CHF/SGD
fn rate_chf_sgd() {
    return 1.519463087248322;
}

// Cross Rate CHF/SEK
fn rate_chf_sek() {
    return 11.791666666666666;
}

// Cross Rate CHF/NOK
fn rate_chf_nok() {
    return 12.042553191489361;
}

// Cross Rate CHF/KRW
fn rate_chf_krw() {
    return 1509.3333333333333;
}

// Cross Rate CHF/INR
fn rate_chf_inr() {
    return 94.33333333333333;
}

// Cross Rate CHF/BRL
fn rate_chf_brl() {
    return 5.631840796019899;
}

// Cross Rate CHF/ZAR
fn rate_chf_zar() {
    return 21.358490566037734;
}

// Cross Rate CHF/MXN
fn rate_chf_mxn() {
    return 19.51724137931034;
}

// Cross Rate CHF/PLN
fn rate_chf_pln() {
    return 4.492063492063491;
}

// Cross Rate CHF/TRY
fn rate_chf_try() {
    return 36.516129032258064;
}

// Cross Rate AUD/USD
fn rate_aud_usd() {
    return 0.655;
}

// Cross Rate AUD/EUR
fn rate_aud_eur() {
    return 0.6036866359447005;
}

// Cross Rate AUD/GBP
fn rate_aud_gbp() {
    return 0.5177865612648221;
}

// Cross Rate AUD/JPY
fn rate_aud_jpy() {
    return 97.76119402985074;
}

// Cross Rate AUD/CHF
fn rate_aud_chf() {
    return 0.5786219081272086;
}

// Cross Rate AUD/CAD
fn rate_aud_cad() {
    return 0.8827493261455526;
}

// Cross Rate AUD/NZD
fn rate_aud_nzd() {
    return 1.0702614379084967;
}

// Cross Rate AUD/CNY
fn rate_aud_cny() {
    return 4.712230215827338;
}

// Cross Rate AUD/HKD
fn rate_aud_hkd() {
    return 5.1171875;
}

// Cross Rate AUD/SGD
fn rate_aud_sgd() {
    return 0.8791946308724833;
}

// Cross Rate AUD/SEK
fn rate_aud_sek() {
    return 6.822916666666667;
}

// Cross Rate AUD/NOK
fn rate_aud_nok() {
    return 6.968085106382979;
}

// Cross Rate AUD/KRW
fn rate_aud_krw() {
    return 873.3333333333334;
}

// Cross Rate AUD/INR
fn rate_aud_inr() {
    return 54.583333333333336;
}

// Cross Rate AUD/BRL
fn rate_aud_brl() {
    return 3.2587064676616917;
}

// Cross Rate AUD/ZAR
fn rate_aud_zar() {
    return 12.358490566037737;
}

// Cross Rate AUD/MXN
fn rate_aud_mxn() {
    return 11.293103448275861;
}

// Cross Rate AUD/PLN
fn rate_aud_pln() {
    return 2.5992063492063493;
}

// Cross Rate AUD/TRY
fn rate_aud_try() {
    return 21.129032258064516;
}

// Cross Rate CAD/USD
fn rate_cad_usd() {
    return 0.742;
}

// Cross Rate CAD/EUR
fn rate_cad_eur() {
    return 0.6838709677419355;
}

// Cross Rate CAD/GBP
fn rate_cad_gbp() {
    return 0.5865612648221344;
}

// Cross Rate CAD/JPY
fn rate_cad_jpy() {
    return 110.74626865671641;
}

// Cross Rate CAD/CHF
fn rate_cad_chf() {
    return 0.6554770318021202;
}

// Cross Rate CAD/AUD
fn rate_cad_aud() {
    return 1.132824427480916;
}

// Cross Rate CAD/NZD
fn rate_cad_nzd() {
    return 1.2124183006535947;
}

// Cross Rate CAD/CNY
fn rate_cad_cny() {
    return 5.338129496402877;
}

// Cross Rate CAD/HKD
fn rate_cad_hkd() {
    return 5.796875;
}

// Cross Rate CAD/SGD
fn rate_cad_sgd() {
    return 0.9959731543624161;
}

// Cross Rate CAD/SEK
fn rate_cad_sek() {
    return 7.729166666666666;
}

// Cross Rate CAD/NOK
fn rate_cad_nok() {
    return 7.8936170212765955;
}

// Cross Rate CAD/KRW
fn rate_cad_krw() {
    return 989.3333333333333;
}

// Cross Rate CAD/INR
fn rate_cad_inr() {
    return 61.83333333333333;
}

// Cross Rate CAD/BRL
fn rate_cad_brl() {
    return 3.691542288557214;
}

// Cross Rate CAD/ZAR
fn rate_cad_zar() {
    return 14.0;
}

// Cross Rate CAD/MXN
fn rate_cad_mxn() {
    return 12.793103448275861;
}

// Cross Rate CAD/PLN
fn rate_cad_pln() {
    return 2.944444444444444;
}

// Cross Rate CAD/TRY
fn rate_cad_try() {
    return 23.93548387096774;
}

// Cross Rate NZD/USD
fn rate_nzd_usd() {
    return 0.612;
}

// Cross Rate NZD/EUR
fn rate_nzd_eur() {
    return 0.5640552995391706;
}

// Cross Rate NZD/GBP
fn rate_nzd_gbp() {
    return 0.4837944664031621;
}

// Cross Rate NZD/JPY
fn rate_nzd_jpy() {
    return 91.34328358208954;
}

// Cross Rate NZD/CHF
fn rate_nzd_chf() {
    return 0.5406360424028269;
}

// Cross Rate NZD/AUD
fn rate_nzd_aud() {
    return 0.9343511450381679;
}

// Cross Rate NZD/CAD
fn rate_nzd_cad() {
    return 0.8247978436657681;
}

// Cross Rate NZD/CNY
fn rate_nzd_cny() {
    return 4.402877697841726;
}

// Cross Rate NZD/HKD
fn rate_nzd_hkd() {
    return 4.78125;
}

// Cross Rate NZD/SGD
fn rate_nzd_sgd() {
    return 0.8214765100671141;
}

// Cross Rate NZD/SEK
fn rate_nzd_sek() {
    return 6.375;
}

// Cross Rate NZD/NOK
fn rate_nzd_nok() {
    return 6.51063829787234;
}

// Cross Rate NZD/KRW
fn rate_nzd_krw() {
    return 816.0;
}

// Cross Rate NZD/INR
fn rate_nzd_inr() {
    return 51.0;
}

// Cross Rate NZD/BRL
fn rate_nzd_brl() {
    return 3.044776119402985;
}

// Cross Rate NZD/ZAR
fn rate_nzd_zar() {
    return 11.547169811320755;
}

// Cross Rate NZD/MXN
fn rate_nzd_mxn() {
    return 10.551724137931034;
}

// Cross Rate NZD/PLN
fn rate_nzd_pln() {
    return 2.4285714285714284;
}

// Cross Rate NZD/TRY
fn rate_nzd_try() {
    return 19.741935483870968;
}

// Cross Rate CNY/USD
fn rate_cny_usd() {
    return 0.139;
}

// Cross Rate CNY/EUR
fn rate_cny_eur() {
    return 0.12811059907834102;
}

// Cross Rate CNY/GBP
fn rate_cny_gbp() {
    return 0.1098814229249012;
}

// Cross Rate CNY/JPY
fn rate_cny_jpy() {
    return 20.74626865671642;
}

// Cross Rate CNY/CHF
fn rate_cny_chf() {
    return 0.122791519434629;
}

// Cross Rate CNY/AUD
fn rate_cny_aud() {
    return 0.21221374045801528;
}

// Cross Rate CNY/CAD
fn rate_cny_cad() {
    return 0.18733153638814018;
}

// Cross Rate CNY/NZD
fn rate_cny_nzd() {
    return 0.22712418300653597;
}

// Cross Rate CNY/HKD
fn rate_cny_hkd() {
    return 1.0859375;
}

// Cross Rate CNY/SGD
fn rate_cny_sgd() {
    return 0.18657718120805372;
}

// Cross Rate CNY/SEK
fn rate_cny_sek() {
    return 1.4479166666666667;
}

// Cross Rate CNY/NOK
fn rate_cny_nok() {
    return 1.4787234042553192;
}

// Cross Rate CNY/KRW
fn rate_cny_krw() {
    return 185.33333333333334;
}

// Cross Rate CNY/INR
fn rate_cny_inr() {
    return 11.583333333333334;
}

// Cross Rate CNY/BRL
fn rate_cny_brl() {
    return 0.691542288557214;
}

// Cross Rate CNY/ZAR
fn rate_cny_zar() {
    return 2.622641509433963;
}

// Cross Rate CNY/MXN
fn rate_cny_mxn() {
    return 2.396551724137931;
}

// Cross Rate CNY/PLN
fn rate_cny_pln() {
    return 0.5515873015873016;
}

// Cross Rate CNY/TRY
fn rate_cny_try() {
    return 4.483870967741936;
}

// Cross Rate HKD/USD
fn rate_hkd_usd() {
    return 0.128;
}

// Cross Rate HKD/EUR
fn rate_hkd_eur() {
    return 0.11797235023041475;
}

// Cross Rate HKD/GBP
fn rate_hkd_gbp() {
    return 0.10118577075098815;
}

// Cross Rate HKD/JPY
fn rate_hkd_jpy() {
    return 19.104477611940297;
}

// Cross Rate HKD/CHF
fn rate_hkd_chf() {
    return 0.11307420494699648;
}

// Cross Rate HKD/AUD
fn rate_hkd_aud() {
    return 0.19541984732824427;
}

// Cross Rate HKD/CAD
fn rate_hkd_cad() {
    return 0.1725067385444744;
}

// Cross Rate HKD/NZD
fn rate_hkd_nzd() {
    return 0.20915032679738563;
}

// Cross Rate HKD/CNY
fn rate_hkd_cny() {
    return 0.9208633093525179;
}

// Cross Rate HKD/SGD
fn rate_hkd_sgd() {
    return 0.17181208053691274;
}

// Cross Rate HKD/SEK
fn rate_hkd_sek() {
    return 1.3333333333333333;
}

// Cross Rate HKD/NOK
fn rate_hkd_nok() {
    return 1.3617021276595744;
}

// Cross Rate HKD/KRW
fn rate_hkd_krw() {
    return 170.66666666666666;
}

// Cross Rate HKD/INR
fn rate_hkd_inr() {
    return 10.666666666666666;
}

// Cross Rate HKD/BRL
fn rate_hkd_brl() {
    return 0.6368159203980099;
}

// Cross Rate HKD/ZAR
fn rate_hkd_zar() {
    return 2.4150943396226414;
}

// Cross Rate HKD/MXN
fn rate_hkd_mxn() {
    return 2.206896551724138;
}

// Cross Rate HKD/PLN
fn rate_hkd_pln() {
    return 0.5079365079365079;
}

// Cross Rate HKD/TRY
fn rate_hkd_try() {
    return 4.129032258064516;
}

// Cross Rate SGD/USD
fn rate_sgd_usd() {
    return 0.745;
}

// Cross Rate SGD/EUR
fn rate_sgd_eur() {
    return 0.6866359447004609;
}

// Cross Rate SGD/GBP
fn rate_sgd_gbp() {
    return 0.5889328063241107;
}

// Cross Rate SGD/JPY
fn rate_sgd_jpy() {
    return 111.19402985074626;
}

// Cross Rate SGD/CHF
fn rate_sgd_chf() {
    return 0.6581272084805654;
}

// Cross Rate SGD/AUD
fn rate_sgd_aud() {
    return 1.1374045801526718;
}

// Cross Rate SGD/CAD
fn rate_sgd_cad() {
    return 1.0040431266846361;
}

// Cross Rate SGD/NZD
fn rate_sgd_nzd() {
    return 1.2173202614379086;
}

// Cross Rate SGD/CNY
fn rate_sgd_cny() {
    return 5.359712230215827;
}

// Cross Rate SGD/HKD
fn rate_sgd_hkd() {
    return 5.8203125;
}

// Cross Rate SGD/SEK
fn rate_sgd_sek() {
    return 7.760416666666666;
}

// Cross Rate SGD/NOK
fn rate_sgd_nok() {
    return 7.925531914893617;
}

// Cross Rate SGD/KRW
fn rate_sgd_krw() {
    return 993.3333333333333;
}

// Cross Rate SGD/INR
fn rate_sgd_inr() {
    return 62.08333333333333;
}

// Cross Rate SGD/BRL
fn rate_sgd_brl() {
    return 3.706467661691542;
}

// Cross Rate SGD/ZAR
fn rate_sgd_zar() {
    return 14.056603773584905;
}

// Cross Rate SGD/MXN
fn rate_sgd_mxn() {
    return 12.844827586206895;
}

// Cross Rate SGD/PLN
fn rate_sgd_pln() {
    return 2.9563492063492065;
}

// Cross Rate SGD/TRY
fn rate_sgd_try() {
    return 24.032258064516128;
}

// Cross Rate SEK/USD
fn rate_sek_usd() {
    return 0.096;
}

// Cross Rate SEK/EUR
fn rate_sek_eur() {
    return 0.08847926267281106;
}

// Cross Rate SEK/GBP
fn rate_sek_gbp() {
    return 0.07588932806324111;
}

// Cross Rate SEK/JPY
fn rate_sek_jpy() {
    return 14.328358208955224;
}

// Cross Rate SEK/CHF
fn rate_sek_chf() {
    return 0.08480565371024736;
}

// Cross Rate SEK/AUD
fn rate_sek_aud() {
    return 0.1465648854961832;
}

// Cross Rate SEK/CAD
fn rate_sek_cad() {
    return 0.1293800539083558;
}

// Cross Rate SEK/NZD
fn rate_sek_nzd() {
    return 0.1568627450980392;
}

// Cross Rate SEK/CNY
fn rate_sek_cny() {
    return 0.6906474820143884;
}

// Cross Rate SEK/HKD
fn rate_sek_hkd() {
    return 0.75;
}

// Cross Rate SEK/SGD
fn rate_sek_sgd() {
    return 0.12885906040268458;
}

// Cross Rate SEK/NOK
fn rate_sek_nok() {
    return 1.0212765957446808;
}

// Cross Rate SEK/KRW
fn rate_sek_krw() {
    return 128.0;
}

// Cross Rate SEK/INR
fn rate_sek_inr() {
    return 8.0;
}

// Cross Rate SEK/BRL
fn rate_sek_brl() {
    return 0.47761194029850745;
}

// Cross Rate SEK/ZAR
fn rate_sek_zar() {
    return 1.8113207547169812;
}

// Cross Rate SEK/MXN
fn rate_sek_mxn() {
    return 1.6551724137931034;
}

// Cross Rate SEK/PLN
fn rate_sek_pln() {
    return 0.38095238095238093;
}

// Cross Rate SEK/TRY
fn rate_sek_try() {
    return 3.096774193548387;
}

// Cross Rate NOK/USD
fn rate_nok_usd() {
    return 0.094;
}

// Cross Rate NOK/EUR
fn rate_nok_eur() {
    return 0.08663594470046083;
}

// Cross Rate NOK/GBP
fn rate_nok_gbp() {
    return 0.07430830039525692;
}

// Cross Rate NOK/JPY
fn rate_nok_jpy() {
    return 14.029850746268655;
}

// Cross Rate NOK/CHF
fn rate_nok_chf() {
    return 0.08303886925795054;
}

// Cross Rate NOK/AUD
fn rate_nok_aud() {
    return 0.1435114503816794;
}

// Cross Rate NOK/CAD
fn rate_nok_cad() {
    return 0.12668463611859837;
}

// Cross Rate NOK/NZD
fn rate_nok_nzd() {
    return 0.15359477124183007;
}

// Cross Rate NOK/CNY
fn rate_nok_cny() {
    return 0.6762589928057553;
}

// Cross Rate NOK/HKD
fn rate_nok_hkd() {
    return 0.734375;
}

// Cross Rate NOK/SGD
fn rate_nok_sgd() {
    return 0.1261744966442953;
}

// Cross Rate NOK/SEK
fn rate_nok_sek() {
    return 0.9791666666666666;
}

// Cross Rate NOK/KRW
fn rate_nok_krw() {
    return 125.33333333333333;
}

// Cross Rate NOK/INR
fn rate_nok_inr() {
    return 7.833333333333333;
}

// Cross Rate NOK/BRL
fn rate_nok_brl() {
    return 0.46766169154228854;
}

// Cross Rate NOK/ZAR
fn rate_nok_zar() {
    return 1.7735849056603774;
}

// Cross Rate NOK/MXN
fn rate_nok_mxn() {
    return 1.6206896551724137;
}

// Cross Rate NOK/PLN
fn rate_nok_pln() {
    return 0.373015873015873;
}

// Cross Rate NOK/TRY
fn rate_nok_try() {
    return 3.032258064516129;
}

// Cross Rate KRW/USD
fn rate_krw_usd() {
    return 0.00075;
}

// Cross Rate KRW/EUR
fn rate_krw_eur() {
    return 0.0006912442396313364;
}

// Cross Rate KRW/GBP
fn rate_krw_gbp() {
    return 0.0005928853754940712;
}

// Cross Rate KRW/JPY
fn rate_krw_jpy() {
    return 0.11194029850746269;
}

// Cross Rate KRW/CHF
fn rate_krw_chf() {
    return 0.0006625441696113075;
}

// Cross Rate KRW/AUD
fn rate_krw_aud() {
    return 0.0011450381679389313;
}

// Cross Rate KRW/CAD
fn rate_krw_cad() {
    return 0.0010107816711590297;
}

// Cross Rate KRW/NZD
fn rate_krw_nzd() {
    return 0.0012254901960784314;
}

// Cross Rate KRW/CNY
fn rate_krw_cny() {
    return 0.0053956834532374095;
}

// Cross Rate KRW/HKD
fn rate_krw_hkd() {
    return 0.005859375;
}

// Cross Rate KRW/SGD
fn rate_krw_sgd() {
    return 0.0010067114093959733;
}

// Cross Rate KRW/SEK
fn rate_krw_sek() {
    return 0.0078125;
}

// Cross Rate KRW/NOK
fn rate_krw_nok() {
    return 0.007978723404255319;
}

// Cross Rate KRW/INR
fn rate_krw_inr() {
    return 0.0625;
}

// Cross Rate KRW/BRL
fn rate_krw_brl() {
    return 0.0037313432835820895;
}

// Cross Rate KRW/ZAR
fn rate_krw_zar() {
    return 0.014150943396226415;
}

// Cross Rate KRW/MXN
fn rate_krw_mxn() {
    return 0.01293103448275862;
}

// Cross Rate KRW/PLN
fn rate_krw_pln() {
    return 0.002976190476190476;
}

// Cross Rate KRW/TRY
fn rate_krw_try() {
    return 0.024193548387096774;
}

// Cross Rate INR/USD
fn rate_inr_usd() {
    return 0.012;
}

// Cross Rate INR/EUR
fn rate_inr_eur() {
    return 0.011059907834101382;
}

// Cross Rate INR/GBP
fn rate_inr_gbp() {
    return 0.009486166007905139;
}

// Cross Rate INR/JPY
fn rate_inr_jpy() {
    return 1.791044776119403;
}

// Cross Rate INR/CHF
fn rate_inr_chf() {
    return 0.01060070671378092;
}

// Cross Rate INR/AUD
fn rate_inr_aud() {
    return 0.0183206106870229;
}

// Cross Rate INR/CAD
fn rate_inr_cad() {
    return 0.016172506738544475;
}

// Cross Rate INR/NZD
fn rate_inr_nzd() {
    return 0.0196078431372549;
}

// Cross Rate INR/CNY
fn rate_inr_cny() {
    return 0.08633093525179855;
}

// Cross Rate INR/HKD
fn rate_inr_hkd() {
    return 0.09375;
}

// Cross Rate INR/SGD
fn rate_inr_sgd() {
    return 0.016107382550335572;
}

// Cross Rate INR/SEK
fn rate_inr_sek() {
    return 0.125;
}

// Cross Rate INR/NOK
fn rate_inr_nok() {
    return 0.1276595744680851;
}

// Cross Rate INR/KRW
fn rate_inr_krw() {
    return 16.0;
}

// Cross Rate INR/BRL
fn rate_inr_brl() {
    return 0.05970149253731343;
}

// Cross Rate INR/ZAR
fn rate_inr_zar() {
    return 0.22641509433962265;
}

// Cross Rate INR/MXN
fn rate_inr_mxn() {
    return 0.20689655172413793;
}

// Cross Rate INR/PLN
fn rate_inr_pln() {
    return 0.047619047619047616;
}

// Cross Rate INR/TRY
fn rate_inr_try() {
    return 0.3870967741935484;
}

// Cross Rate BRL/USD
fn rate_brl_usd() {
    return 0.201;
}

// Cross Rate BRL/EUR
fn rate_brl_eur() {
    return 0.18525345622119818;
}

// Cross Rate BRL/GBP
fn rate_brl_gbp() {
    return 0.1588932806324111;
}

// Cross Rate BRL/JPY
fn rate_brl_jpy() {
    return 30.0;
}

// Cross Rate BRL/CHF
fn rate_brl_chf() {
    return 0.17756183745583043;
}

// Cross Rate BRL/AUD
fn rate_brl_aud() {
    return 0.3068702290076336;
}

// Cross Rate BRL/CAD
fn rate_brl_cad() {
    return 0.27088948787061995;
}

// Cross Rate BRL/NZD
fn rate_brl_nzd() {
    return 0.3284313725490196;
}

// Cross Rate BRL/CNY
fn rate_brl_cny() {
    return 1.4460431654676258;
}

// Cross Rate BRL/HKD
fn rate_brl_hkd() {
    return 1.5703125;
}

// Cross Rate BRL/SGD
fn rate_brl_sgd() {
    return 0.26979865771812084;
}

// Cross Rate BRL/SEK
fn rate_brl_sek() {
    return 2.09375;
}

// Cross Rate BRL/NOK
fn rate_brl_nok() {
    return 2.138297872340426;
}

// Cross Rate BRL/KRW
fn rate_brl_krw() {
    return 268.0;
}

// Cross Rate BRL/INR
fn rate_brl_inr() {
    return 16.75;
}

// Cross Rate BRL/ZAR
fn rate_brl_zar() {
    return 3.7924528301886795;
}

// Cross Rate BRL/MXN
fn rate_brl_mxn() {
    return 3.4655172413793105;
}

// Cross Rate BRL/PLN
fn rate_brl_pln() {
    return 0.7976190476190477;
}

// Cross Rate BRL/TRY
fn rate_brl_try() {
    return 6.483870967741936;
}

// Cross Rate ZAR/USD
fn rate_zar_usd() {
    return 0.053;
}

// Cross Rate ZAR/EUR
fn rate_zar_eur() {
    return 0.04884792626728111;
}

// Cross Rate ZAR/GBP
fn rate_zar_gbp() {
    return 0.04189723320158103;
}

// Cross Rate ZAR/JPY
fn rate_zar_jpy() {
    return 7.910447761194029;
}

// Cross Rate ZAR/CHF
fn rate_zar_chf() {
    return 0.046819787985865724;
}

// Cross Rate ZAR/AUD
fn rate_zar_aud() {
    return 0.08091603053435113;
}

// Cross Rate ZAR/CAD
fn rate_zar_cad() {
    return 0.07142857142857142;
}

// Cross Rate ZAR/NZD
fn rate_zar_nzd() {
    return 0.08660130718954248;
}

// Cross Rate ZAR/CNY
fn rate_zar_cny() {
    return 0.38129496402877694;
}

// Cross Rate ZAR/HKD
fn rate_zar_hkd() {
    return 0.4140625;
}

// Cross Rate ZAR/SGD
fn rate_zar_sgd() {
    return 0.07114093959731543;
}

// Cross Rate ZAR/SEK
fn rate_zar_sek() {
    return 0.5520833333333333;
}

// Cross Rate ZAR/NOK
fn rate_zar_nok() {
    return 0.5638297872340425;
}

// Cross Rate ZAR/KRW
fn rate_zar_krw() {
    return 70.66666666666666;
}

// Cross Rate ZAR/INR
fn rate_zar_inr() {
    return 4.416666666666666;
}

// Cross Rate ZAR/BRL
fn rate_zar_brl() {
    return 0.26368159203980096;
}

// Cross Rate ZAR/MXN
fn rate_zar_mxn() {
    return 0.9137931034482758;
}

// Cross Rate ZAR/PLN
fn rate_zar_pln() {
    return 0.21031746031746032;
}

// Cross Rate ZAR/TRY
fn rate_zar_try() {
    return 1.7096774193548387;
}

// Cross Rate MXN/USD
fn rate_mxn_usd() {
    return 0.058;
}

// Cross Rate MXN/EUR
fn rate_mxn_eur() {
    return 0.053456221198156684;
}

// Cross Rate MXN/GBP
fn rate_mxn_gbp() {
    return 0.04584980237154151;
}

// Cross Rate MXN/JPY
fn rate_mxn_jpy() {
    return 8.656716417910449;
}

// Cross Rate MXN/CHF
fn rate_mxn_chf() {
    return 0.051236749116607784;
}

// Cross Rate MXN/AUD
fn rate_mxn_aud() {
    return 0.08854961832061069;
}

// Cross Rate MXN/CAD
fn rate_mxn_cad() {
    return 0.07816711590296496;
}

// Cross Rate MXN/NZD
fn rate_mxn_nzd() {
    return 0.09477124183006537;
}

// Cross Rate MXN/CNY
fn rate_mxn_cny() {
    return 0.41726618705035967;
}

// Cross Rate MXN/HKD
fn rate_mxn_hkd() {
    return 0.453125;
}

// Cross Rate MXN/SGD
fn rate_mxn_sgd() {
    return 0.07785234899328859;
}

// Cross Rate MXN/SEK
fn rate_mxn_sek() {
    return 0.6041666666666666;
}

// Cross Rate MXN/NOK
fn rate_mxn_nok() {
    return 0.6170212765957447;
}

// Cross Rate MXN/KRW
fn rate_mxn_krw() {
    return 77.33333333333333;
}

// Cross Rate MXN/INR
fn rate_mxn_inr() {
    return 4.833333333333333;
}

// Cross Rate MXN/BRL
fn rate_mxn_brl() {
    return 0.2885572139303483;
}

// Cross Rate MXN/ZAR
fn rate_mxn_zar() {
    return 1.0943396226415094;
}

// Cross Rate MXN/PLN
fn rate_mxn_pln() {
    return 0.23015873015873017;
}

// Cross Rate MXN/TRY
fn rate_mxn_try() {
    return 1.870967741935484;
}

// Cross Rate PLN/USD
fn rate_pln_usd() {
    return 0.252;
}

// Cross Rate PLN/EUR
fn rate_pln_eur() {
    return 0.23225806451612904;
}

// Cross Rate PLN/GBP
fn rate_pln_gbp() {
    return 0.19920948616600792;
}

// Cross Rate PLN/JPY
fn rate_pln_jpy() {
    return 37.61194029850746;
}

// Cross Rate PLN/CHF
fn rate_pln_chf() {
    return 0.22261484098939932;
}

// Cross Rate PLN/AUD
fn rate_pln_aud() {
    return 0.3847328244274809;
}

// Cross Rate PLN/CAD
fn rate_pln_cad() {
    return 0.33962264150943394;
}

// Cross Rate PLN/NZD
fn rate_pln_nzd() {
    return 0.411764705882353;
}

// Cross Rate PLN/CNY
fn rate_pln_cny() {
    return 1.8129496402877696;
}

// Cross Rate PLN/HKD
fn rate_pln_hkd() {
    return 1.96875;
}

// Cross Rate PLN/SGD
fn rate_pln_sgd() {
    return 0.338255033557047;
}

// Cross Rate PLN/SEK
fn rate_pln_sek() {
    return 2.625;
}

// Cross Rate PLN/NOK
fn rate_pln_nok() {
    return 2.6808510638297873;
}

// Cross Rate PLN/KRW
fn rate_pln_krw() {
    return 336.0;
}

// Cross Rate PLN/INR
fn rate_pln_inr() {
    return 21.0;
}

// Cross Rate PLN/BRL
fn rate_pln_brl() {
    return 1.253731343283582;
}

// Cross Rate PLN/ZAR
fn rate_pln_zar() {
    return 4.754716981132075;
}

// Cross Rate PLN/MXN
fn rate_pln_mxn() {
    return 4.344827586206897;
}

// Cross Rate PLN/TRY
fn rate_pln_try() {
    return 8.129032258064516;
}

// Cross Rate TRY/USD
fn rate_try_usd() {
    return 0.031;
}

// Cross Rate TRY/EUR
fn rate_try_eur() {
    return 0.02857142857142857;
}

// Cross Rate TRY/GBP
fn rate_try_gbp() {
    return 0.02450592885375494;
}

// Cross Rate TRY/JPY
fn rate_try_jpy() {
    return 4.626865671641791;
}

// Cross Rate TRY/CHF
fn rate_try_chf() {
    return 0.02738515901060071;
}

// Cross Rate TRY/AUD
fn rate_try_aud() {
    return 0.04732824427480916;
}

// Cross Rate TRY/CAD
fn rate_try_cad() {
    return 0.04177897574123989;
}

// Cross Rate TRY/NZD
fn rate_try_nzd() {
    return 0.05065359477124183;
}

// Cross Rate TRY/CNY
fn rate_try_cny() {
    return 0.22302158273381292;
}

// Cross Rate TRY/HKD
fn rate_try_hkd() {
    return 0.2421875;
}

// Cross Rate TRY/SGD
fn rate_try_sgd() {
    return 0.04161073825503356;
}

// Cross Rate TRY/SEK
fn rate_try_sek() {
    return 0.3229166666666667;
}

// Cross Rate TRY/NOK
fn rate_try_nok() {
    return 0.32978723404255317;
}

// Cross Rate TRY/KRW
fn rate_try_krw() {
    return 41.333333333333336;
}

// Cross Rate TRY/INR
fn rate_try_inr() {
    return 2.5833333333333335;
}

// Cross Rate TRY/BRL
fn rate_try_brl() {
    return 0.15422885572139303;
}

// Cross Rate TRY/ZAR
fn rate_try_zar() {
    return 0.5849056603773585;
}

// Cross Rate TRY/MXN
fn rate_try_mxn() {
    return 0.5344827586206896;
}

// Cross Rate TRY/PLN
fn rate_try_pln() {
    return 0.12301587301587301;
}
