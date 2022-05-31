const std = @import("std");
const vector = @import("vector.zig");
const Color = vector.Color;
const Vec3 = vector.Vec3;
const Point3 = vector.Point3;

pub const Ray = struct {
    orig: Point3 = Point3{},
    dir: Vec3 = Vec3{},

    const Self = @This();

    pub fn init(origin: Point3, direction: Vec3) Self {
        return Self{ .orig = origin, .dir = direction };
    }

    pub fn at(self: Self, t: f32) Point3 {
        return vector.add(self.orig, vector.multScalar(self.dir, t));
    }
};

// BEGIN TESTS
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
test "create Ray" {
    var test_ray = Ray.init(Point3.init(1, 2, 4), Vec3.init(5, 2, 1));
    try expect(test_ray.orig.x() == @as(f32, 1));
    try expect(test_ray.dir.y() == @as(f32, 2));
    var orig = test_ray.orig;
    orig.e[0] = 12;
    try expect(test_ray.orig.x() == @as(f32, 1));
}

test "Ray at" {
    var test_ray = Ray.init(Point3.init(1, 2, 4), Vec3.init(5, 2, 1));
    var at = test_ray.at(2);
    try expectEqual([3]f32{ 11, 6, 6 }, at.e);
}

// END TESTS

// MAIN

pub fn rayColor(r: Ray) Color {
    const unit_direction: Vec3 = vector.unitVector(r.dir);
    const t = 0.5 * (unit_direction.y() + 1.0);
    const raycolor = vector.add(vector.multScalar(Color.init(1.0, 1.0, 1.0), (1.0 - t)), vector.multScalar(Color.init(0.5, 0.7, 1.0), t));
    return raycolor;
}
pub fn main() anyerror!void {

    // Image
    const aspect_ratio: f32 = 16.0 / 9.0;
    const image_width: u32 = 400;
    const image_height: u32 = @floatToInt(u32, @as(f32, image_width) / aspect_ratio);

    // Camera
    const viewport_height: f32 = 2.0;
    const viewport_width: f32 = viewport_height * aspect_ratio;
    const focal_length: f32 = 1.0;

    const origin: Point3 = Point3.init(0, 0, 0);
    const horizontal: Vec3 = Vec3.init(viewport_width, 0, 0);
    const vertical: Vec3 = Vec3.init(0, viewport_height, 0);
    var lower_left_corner = vector.sub(origin, vector.add(vector.divScalar(horizontal, 2), vector.divScalar(vertical, 2)));
    lower_left_corner = vector.sub(lower_left_corner, Vec3.init(0, 0, focal_length));

    std.log.info("Starting the program\n", .{});
    const stdoutwriter = std.io.getStdOut().writer();
    const stderrwriter = std.io.getStdErr().writer();

    // creating the image
    try stdoutwriter.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });
    var j: i32 = image_height - 1;
    while (j >= 0) : (j -= 1) {
        try stderrwriter.print("Scanlines remaining: {d}\n", .{j});
        var i: i32 = 0;
        while (i < image_width) : (i += 1) {
            const u = @intToFloat(f32, i) / @as(f32, image_width - 1);
            const v = @intToFloat(f32, j) / @as(f32, image_height - 1);
            const r: Ray = Ray.init(origin, vector.sub(vector.add(lower_left_corner, vector.add(vector.multScalar(horizontal, u), vector.multScalar(vertical, v))), origin));
            const pixel_color: Color = rayColor(r);
            try vector.writeColor(stdoutwriter, pixel_color);
        }
    }
}
