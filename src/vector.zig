const std = @import("std");

pub const Vec3 = struct {
    e: @Vector(3, f32) = [3]f32{ 0, 0, 0 },

    const Self = @This();

    pub fn init(e1: f32, e2: f32, e3: f32) Self {
        return Self{ .e = [3]f32{ e1, e2, e3 } };
    }
    fn x(self: Self) f32 {
        return self.e[0];
    }
    fn y(self: Self) f32 {
        return self.e[1];
    }
    fn z(self: Self) f32 {
        return self.e[2];
    }

    fn length(self: Self) f32 {
        return @sqrt(self.lengthSquared());
    }

    fn lengthSquared(self: Self) f32 {
        return self.e[0] * self.e[0] + self.e[1] * self.e[1] + self.e[2] * self.e[2];
    }

    //    pub fn format(
    //        self: Self,
    //        comptime fmt: []const u8,
    //        options: std.fmt.FormatOptions,
    //        writer: anytype,
    //    ) !void {
    //        _ = fmt;
    //        _ = options;
    //        const ir = @floatToInt(u32, 255.999 * self.x());
    //        const ig = @floatToInt(u32, 255.999 * self.y());
    //        const ib = @floatToInt(u32, 255.999 * self.z());
    //        try writer.print("{d} {d} {d}\n", .{ ir, ig, ib });
    //    }
};

pub fn negate(v: Vec3) Vec3 {
    return Vec3{ .e = -v.e };
}

pub fn add(u: Vec3, v: Vec3) Vec3 {
    return Vec3{ .e = u.e + v.e };
}

pub fn sub(u: Vec3, v: Vec3) Vec3 {
    return Vec3{ .e = u.e - v.e };
}

pub fn mult(u: Vec3, v: Vec3) Vec3 {
    return Vec3{ .e = u.e * v.e };
}

pub fn multScalar(u: Vec3, t: f32) Vec3 {
    return Vec3{ .e = u.e * @splat(3, t) };
}

pub fn divScalar(u: Vec3, t: f32) Vec3 {
    return multScalar(u, 1 / t);
}

pub fn dot(u: Vec3, v: Vec3) f32 {
    return @reduce(.Add, u.e * v.e);
}
pub fn cross(u: Vec3, v: Vec3) f32 {
    return Vec3{ .e = [3]f32{
        u.e[1] * v.e[2] - u.e[2] * v.e[1],
        u.e[2] * v.e[0] - u.e[0] * v.e[2],
        u.e[0] * v.e[1] - u.e[1] * v.e[0],
    } };
}

pub fn unitVector(v: Vec3) Vec3 {
    return divScalar(v, v.length());
}

// Note (Subil): I don't like I have to use anytype for out.
// But since std.io.Writer is a function that needs take values, I
// can't use that as the type signature. So we're stuck with anytype
pub fn writeColor(out: anytype, pixel_color: Color) !void {
    const ir = @floatToInt(u32, 255.999 * pixel_color.x());
    const ig = @floatToInt(u32, 255.999 * pixel_color.y());
    const ib = @floatToInt(u32, 255.999 * pixel_color.z());
    try out.print("{d} {d} {d}\n", .{ ir, ig, ib });
}

pub const Point3 = Vec3;
pub const Color = Vec3;

// BEGIN TESTS
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const testing_allocator = std.testing.allocator;
test "init vec3" {
    var vec = Vec3.init(5, 6, 8);
    try expect(vec.e[1] == @as(f32, 6));
    try expect(vec.x() == @as(f32, 5));
    var negvec = Vec3{ .e = -vec.e };
    try expectEqual(negvec.e, -vec.e);
    try expectEqual(vec.length(), @sqrt(@as(f32, 5 * 5 + 6 * 6 + 8 * 8)));
}

test "Vec3Functions" {
    var u = Vec3{ .e = [3]f32{ 1, 2, 3 } };
    var v = Vec3{ .e = [3]f32{ 4, 5, 6 } };
    try expectEqual([3]f32{ 5, 7, 9 }, add(u, v).e);
    try expectEqual(@Vector(3, f32), @TypeOf(add(v, v).e));
    try expectEqual([3]f32{ -3, -3, -3 }, sub(u, v).e);
    try expectEqual([3]f32{ 4, 10, 18 }, mult(u, v).e);
    try expectEqual([3]f32{ 2, 4, 6 }, multScalar(u, 2).e);
    try expectEqual([3]f32{ 2, 2.5, 3 }, divScalar(v, 2).e);
    try expectEqual(@as(f32, 32), dot(u, v));

    v = Vec3{ .e = [3]f32{ 0, 3, 4 } };
    try expectEqual([3]f32{ 0, 0.6, 0.8 }, unitVector(v).e);
    v = Vec3{ .e = [3]f32{ 0.1, 0.2, 0.3 } };
    //    std.debug.print("{any}\n", .{v});
}

// END TESTS
