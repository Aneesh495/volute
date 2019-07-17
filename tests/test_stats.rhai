import "lib/stats/descriptive" as d;
import "lib/stats/streaming" as s;
import "lib/stats/outliers" as o;
import "lib/stats/regression" as r;
import "lib/testing/assert" as test;

// 1. Descriptive
let data = [10, 20, 30, 40, 50];
test::assert_near(d::mean(data), 30.0, 0.001, "mean check");
test::assert_near(d::variance(data), 250.0, 0.001, "variance check");
test::assert_near(d::median(data), 30.0, 0.001, "median check");

// 2. Streaming Welford
let w = s::new_welford();
for x in data {
    w = s::update_welford(w, x);
}
test::assert_eq(w.count, 5, "welford count");
test::assert_near(w.mean, 30.0, 0.001, "welford mean");
test::assert_near(s::get_variance(w), 250.0, 0.001, "welford variance");

// 3. EWMA
let ewma = s::new_ewma(0.5);
ewma = s::update_ewma(ewma, 100.0);
ewma = s::update_ewma(ewma, 200.0);
test::assert_near(ewma.value, 150.0, 0.001, "ewma update");

// 4. Outliers
let z = o::z_score(60.0, 30.0, 15.811);
test::assert_near(z, 1.897, 0.01, "z score check");
test::assert(!o::is_z_outlier(60.0, 30.0, 15.811, 3.0), "z outlier false");
test::assert(o::is_z_outlier(100.0, 30.0, 15.811, 3.0), "z outlier true");

// 5. Linear Regression
let xs = [1.0, 2.0, 3.0, 4.0, 5.0];
let ys = [2.0, 4.0, 6.0, 8.0, 10.0];
let model = r::fit_linear_regression(xs, ys);
test::assert(model.is_valid, "model validity");
test::assert_near(model.slope, 2.0, 0.001, "regression slope");
test::assert_near(model.intercept, 0.0, 0.001, "regression intercept");
test::assert_near(model.r_squared, 1.0, 0.001, "perfect r-squared");
test::assert_near(r::predict(model, 10.0), 20.0, 0.001, "prediction check");
