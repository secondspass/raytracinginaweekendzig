const std = @import("std");
const vector = @import("vector.zig");
const Color = vector.Color;

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
