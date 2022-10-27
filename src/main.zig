const std = @import("std");
const eql = std.mem.eql;

fn readConfig(arraylist: *std.ArrayList([]u8), allocator: std.mem.Allocator) !void {
    const file = try std.fs.cwd().openFile(".pack", .{});
    defer file.close();
    const reader = file.reader();

    // reading file into arraylist sep by \n
    while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 4096)) |line| {
        try arraylist.append(line);
    }
}

fn equal(a: []const u8, b: []const u8) bool {
    return eql(u8, a, b);
}

const help =
    \\Help text
    \\
;

pub fn main() !u8 {
    // const log = std.io.getStdOut().writer().print;
    // const err = std.io.getStdErr().writer().print;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try std.io.getStdErr().writer().print("No command passed.\n\n" ++ help, .{});
        return 1;
    }

    const command = args[1];

    // -- pack help
    if (equal("help", command)) {
        std.debug.print(help, .{});
        return 0;
    }

    // -- pack init
    if (equal("init", command)) {
        const file = std.fs.cwd().createFile(".pack", .{ .exclusive = true }) catch |err| {
            switch (err) {
                error.PathAlreadyExists => {
                    std.debug.print(".pack file already exists in current directory. Skipping.\n", .{});
                    return 0;
                },
                else => {
                    std.debug.print("Surprising.\n", .{});
                    return err;
                },
            }
        };
        defer file.close();
        std.debug.print("Created empty .pack file in current directory.\n", .{});
        return 0;
    }

    const file = try std.fs.cwd().openFile(".pack", .{ .mode = .read_write });
    defer file.close();

    // -- pack add
    if (equal("add", command)) {
        if (args.len < 3) {
            try std.io.getStdErr().writer().print("Pass at least one file to add.\n", .{});
            return 2;
        }
        const files = args[2..];
        for (files) |f| {
            try file.seekFromEnd(0);
            try file.writeAll(f);
            try file.writeAll("\n");
        }

        return 0;
    }

    // -- pack pack
    if (equal("pack", command)) {
        // try to read config
        const reader = file.reader();
        var configList = std.ArrayList([]u8).init(allocator);
        defer configList.deinit();
        defer for (configList.items) |line| allocator.free(line);

        // reading file into arraylist sep by \n
        while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 4096)) |line| {
            try configList.append(line);
        }

        std.debug.print("\nPacking:\n\n", .{});
        for (configList.items) |line| std.debug.print(" {s}\n", .{line});
        std.debug.print("\nDone!\n\n", .{});
        return 0;
    }

    std.debug.print("Unknown command: {s}\n\n" ++ help, .{command});
    return 2;
}
