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
    const Writer = std.fs.File.Writer;
    fn help(out: Writer) !u8 {
        try out.writeAll(
            \\Help text
            \\
        );
        return 1;
    }
    fn init(cwd: std.fs.Dir, out: Writer) !void {
        const file = cwd.createFile(".pack", .{ .exclusive = true }) catch |err| {
            if (err == error.PathAlreadyExists)
                try out.writeAll(".pack file already exists in current directory. Skipping.\n");
            return err;
        };
        defer file.close();
        try out.writeAll("Created empty .pack file in current directory.\n");
    }
    fn add(cwd: std.fs.Dir, files: []const []const u8, out: Writer) !u8 {
        if (files.len == 0) {
            try out.print("Pass at least one file to add.\n", .{});
            return 2;
        }
        const file = cwd.openFile(".pack", .{ .mode = .read_write }) catch |err| {
            if (err == error.FileNotFound) {
                try out.writeAll(".pack file not found. Run `pack init` first.\n");
                return 1;
            }
            return err;
        };
        defer file.close();

        var buf: [256]u8 = undefined;

        // TODO: don't allow duplicates in pack file
        for (files) |f| {
            const absolute_path = cwd.realpath(f, &buf) catch |err| {
                if (err == error.FileNotFound) {
                    try out.print(" - {s} doesn't exist. Skipping.\n", .{f});
                    continue;
                }
                return err;
            };
            try file.seekFromEnd(0);
            try file.writeAll(absolute_path);
            try file.writeAll("\n");
        }

        return 0;
    }
    fn pack(cwd: std.fs.Dir, out: Writer) !void {
        const file = try cwd.openFile(".pack", .{ .mode = .read_only });
        defer file.close();
        // try to read config
        const reader = file.reader();

        var buf: [4096]u8 = undefined;
        while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            // TODO(mkr): actually copy files
            try out.print("- {s}\n", .{line});
        }
        try out.writeAll("\nDone! You should probably commit changes.\n\n");
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
        .help => return try Pack.help(err),
        .init => try Pack.init(std.fs.cwd(), err),
        .add => return try Pack.add(std.fs.cwd(), args[2..], err),
        .pack => try Pack.pack(std.fs.cwd(), err),
        .unpack => unreachable, // TODO
    }
    return 0;
}
