# pack

pack -- pack and move at a moment's notice.

## Building

Use zig master. Just run

```shell
zig build
```

## Usage

Only some commands are implemented so far.

### pack init

Creates an empty `.pack` file in cwd if it doesn't exist yet.

### pack add [...files]

Adds given file paths to `.pack` file.

### pack pack (not implemented)

Pulls the files specified in `.pack` to current directory, preserving their paths and creates an `unpack` binary next to them. This repo can be committed to git.

### ./unpack (not implemented)

Since pack creates an unpack file, target machine doesn't need `pack` to unpack a pack-ed archive.
