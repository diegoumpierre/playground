const std = @import("std");

pub fn calculateMinimumHP(allocator: *std.mem.Allocator, dungeon: [][]i32) !i32 {
    const m = dungeon.len;
    const n = dungeon[0].len;

    var dp = try allocator.alloc([]i32, m + 1);
    defer allocator.free(dp);

    for (dp, 0..) |_, i| {
        dp[i] = try allocator.alloc(i32, n + 1);
        defer allocator.free(dp[i]);
        for (dp[i]) |*cell| {
            cell.* = std.math.maxInt(i32); // Integer.MAX_VALUE
        }
    }

    dp[m][n - 1] = 1;
    dp[m - 1][n] = 1;

    var i: usize = m;
    while (i > 0) : (i -= 1) {
        var j: usize = n;
        while (j > 0) : (j -= 1) {
            const row = i - 1;
            const col = j - 1;
            const down = dp[row + 1][col];
            const right = dp[row][col + 1];
            const min_health = @min(down, right) - dungeon[row][col];
            dp[row][col] = @max(1, min_health);
        }
    }

    return dp[0][0];
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const dungeon_data = [_][3]i32{
        [3]i32{ -2, -3, 3 },
        [3]i32{ -5, -10, 1 },
        [3]i32{ 10, 30, -5 },
    };

    const dungeon: [][]i32 = &[_][]i32{
        dungeon_data[0][0..],
        dungeon_data[1][0..],
        dungeon_data[2][0..],
    };

    const result = try calculateMinimumHP(allocator, dungeon);
    std.debug.print("Minimum initial health required: {}", .{result});
}
