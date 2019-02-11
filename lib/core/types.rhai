/*
 * Core Type Reflection and Schema Validation Module
 *
 * Provides runtime type assertions, deep equality checks, schema enforcement,
 * and value transformations for streaming records.
 */

// Return string representation of value type
fn get_type(val) {
    return type_of(val);
}

// Check if value is null (unit)
fn is_null(val) {
    return type_of(val) == "()";
}

// Check if value is a boolean
fn is_bool(val) {
    return type_of(val) == "bool";
}

// Check if value is an integer
fn is_int(val) {
    return type_of(val) == "i64" || type_of(val) == "i32";
}

// Check if value is a float
fn is_float(val) {
    return type_of(val) == "f64" || type_of(val) == "f32";
}

// Check if value is any numeric type
fn is_numeric(val) {
    let t = type_of(val);
    return t == "i64" || t == "i32" || t == "f64" || t == "f32";
}

// Check if value is a string
fn is_string(val) {
    return type_of(val) == "string";
}

// Check if value is an array
fn is_array(val) {
    return type_of(val) == "array";
}

// Check if value is a map (object)
fn is_map(val) {
    return type_of(val) == "map";
}

// Convert any numeric value to float
fn to_float(val) {
    if is_float(val) {
        return val;
    }
    if is_int(val) {
        return val * 1.0;
    }
    if is_string(val) {
        return parse_float(val);
    }
    return 0.0;
}

// Convert any numeric value to integer
fn to_int(val) {
    if is_int(val) {
        return val;
    }
    if is_float(val) {
        return val.to_int();
    }
    if is_string(val) {
        return parse_int(val);
    }
    return 0;
}

// Deep clone a map or primitive
fn deep_clone(val) {
    if is_map(val) {
        let cloned = #{};
        for k in val.keys() {
            cloned[k] = deep_clone(val[k]);
        }
        return cloned;
    }
    if is_array(val) {
        let cloned = [];
        for item in val {
            cloned.push(deep_clone(item));
        }
        return cloned;
    }
    return val;
}

// Deep merge two maps; right overrides left
fn deep_merge(left, right) {
    if !is_map(left) || !is_map(right) {
        return deep_clone(right);
    }
    let result = deep_clone(left);
    for k in right.keys() {
        if result.contains(k) && is_map(result[k]) && is_map(right[k]) {
            result[k] = deep_merge(result[k], right[k]);
        } else {
            result[k] = deep_clone(right[k]);
        }
    }
    return result;
}

// Deep equality check between two arbitrary values
fn deep_equals(a, b) {
    let ta = type_of(a);
    let tb = type_of(b);
    if ta != tb {
        return false;
    }
    if is_map(a) {
        let keys_a = a.keys();
        let keys_b = b.keys();
        if keys_a.len() != keys_b.len() {
            return false;
        }
        for k in keys_a {
            if !b.contains(k) {
                return false;
            }
            if !deep_equals(a[k], b[k]) {
                return false;
            }
        }
        return true;
    }
    if is_array(a) {
        if a.len() != b.len() {
            return false;
        }
        for i in 0..a.len() {
            if !deep_equals(a[i], b[i]) {
                return false;
            }
        }
        return true;
    }
    return a == b;
}

// Validate map against expected schema definition
fn validate_schema(data, schema) {
    if !is_map(data) || !is_map(schema) {
        return false;
    }
    for field_name in schema.keys() {
        let rule = schema[field_name];
        let required = rule.contains("required") && rule["required"];
        if !data.contains(field_name) {
            if required {
                return false;
            }
            continue;
        }
        let val = data[field_name];
        if rule.contains("type") {
            let expected_type = rule["type"];
            if expected_type == "numeric" {
                if !is_numeric(val) {
                    return false;
                }
            } else if type_of(val) != expected_type {
                return false;
            }
        }
        if rule.contains("min") && is_numeric(val) {
            if val < rule["min"] {
                return false;
            }
        }
        if rule.contains("max") && is_numeric(val) {
            if val > rule["max"] {
                return false;
            }
        }
    }
    return true;
}
