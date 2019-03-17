/*
 * Point-in-Polygon Ray Casting and Bounding Box Verification
 *
 * Implements Jordan curve theorem ray-casting algorithm for geofencing.
 */

// Check if point (px, py) is inside polygon defined by array of [x, y] vertices
fn point_in_polygon(px, py, vertices) {
    let num_verts = vertices.len();
    if num_verts < 3 {
        return false;
    }

    let inside = false;
    let j = num_verts - 1;

    for i in 0..num_verts {
        let xi = vertices[i][0] * 1.0;
        let yi = vertices[i][1] * 1.0;
        let xj = vertices[j][0] * 1.0;
        let yj = vertices[j][1] * 1.0;

        let intersect = ((yi > py) != (yj > py)) &&
            (px < (xj - xi) * (py - yi) / (yj - yi) + xi);

        if intersect {
            inside = !inside;
        }
        j = i;
    }

    return inside;
}

// Compute bounding box [min_x, min_y, max_x, max_y] of polygon
fn polygon_bounding_box(vertices) {
    if vertices.is_empty() {
        return [0.0, 0.0, 0.0, 0.0];
    }
    let min_x = vertices[0][0] * 1.0;
    let max_x = vertices[0][0] * 1.0;
    let min_y = vertices[0][1] * 1.0;
    let max_y = vertices[0][1] * 1.0;

    for v in vertices {
        let x = v[0] * 1.0;
        let y = v[1] * 1.0;
        if x < min_x { min_x = x; }
        if x > max_x { max_x = x; }
        if y < min_y { min_y = y; }
        if y > max_y { max_y = y; }
    }

    return [min_x, min_y, max_x, max_y];
}

// Quick reject test against bounding box
fn is_point_in_bbox(px, py, bbox) {
    return px >= bbox[0] && px <= bbox[2] && py >= bbox[1] && py <= bbox[3];
}
