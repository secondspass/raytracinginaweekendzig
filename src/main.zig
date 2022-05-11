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
};

// tests
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

// MAIN

pub fn main() anyerror!void {
    const image_width: u32 = 256;
    const image_height: u32 = 256;
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
            var pixel_color = Color.init(@intToFloat(f32, i) / @intToFloat(f32, (image_width - 1)), @intToFloat(f32, j) / @intToFloat(f32, (image_height - 1)), 0.25);
            try vector.writeColor(stdoutwriter, pixel_color);
        }
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
