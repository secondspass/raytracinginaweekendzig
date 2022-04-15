const std = @import("std");

pub fn main() anyerror!void {
    const image_width: u32 = 256;
    const image_height: u32 = 256;
    std.log.info("Starting the program\n", .{});
    const stdoutwriter = std.io.getStdOut().writer();

    // creating the image
    try stdoutwriter.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });
    var j: i32 = image_height - 1;
    while (j >= 0) : (j -= 1) {
        var i: i32 = 0;
        while (i < image_width) : (i += 1) {
            const r = @intToFloat(f32, i) / @intToFloat(f32, (image_width - 1));
            const g = @intToFloat(f32, j) / @intToFloat(f32, (image_height - 1));
            const b = 0.25;

            const ir = @floatToInt(u32, 255.999 * r);
            const ig = @floatToInt(u32, 255.999 * g);
            const ib = @floatToInt(u32, 255.999 * b);
            try stdoutwriter.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
    std.debug.print("blah blah");
}