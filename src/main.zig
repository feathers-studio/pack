const std = @import("std");

const Pack = struct {
    const Command = enum {
        help,
        init,
        add,
        pack,
        unpack,
        fn from(str: []const u8) Command {
            return std.meta.stringToEnum(Command, str) orelse .help;
        }
    };
    fn help(out: anytype) !void {
        try out.writeAll(
            \\Help text
            \\
        );
    }
    fn init(out: anytype) !void {
        const file = std.fs.cwd().createFile(".pack", .{ .exclusive = true }) catch |err| {
            switch (err) {
                error.PathAlreadyExists => {
                    try out.writeAll(".pack file already exists in current directory. Skipping.\n");
                    return;
                },
                else => {
                    try out.writeAll("Surprising.\n");
                    return err;
                },
            }
        };
        defer file.close();
        try out.writeAll("Created empty .pack file in current directory.\n");
    }
    fn add(files: []const []const u8, out: anytype) !u8 {
        if (files.len == 0) {
            try out.print("Pass at least one file to add.\n", .{});
            return 2;
        }
        const file = try std.fs.cwd().openFile(".pack", .{ .mode = .read_write });
        defer file.close();

        for (files) |f| {
            try file.seekFromEnd(0);
            try file.writeAll(f);
            try file.writeAll("\n");
        }

        return 0;
    }
    fn pack(allocator: std.mem.Allocator) !void {
        const file = try std.fs.cwd().openFile(".pack", .{ .mode = .read_write });
        defer file.close();
        // try to read config
        const reader = file.reader();

        std.debug.print("Packing:\n", .{});
        while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 4096)) |line| {
            defer allocator.free(line);
            // TODO(mkr): actually copy files
            std.debug.print("- {s}\n", .{line});
        }
        std.debug.print("\nDone! You should probably commit changes.\n\n", .{});
    }
};

pub fn main() !u8 {
    const err = std.io.getStdErr().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    switch (Pack.Command.from(if (args.len >= 2) args[1] else "help")) {
        .help => try Pack.help(err),
        .init => try Pack.init(err),
        .add => return Pack.add(args[2..], err),
        .pack => try Pack.pack(allocator),
        .unpack => unreachable, // TODO
    }
    return 0;
}
