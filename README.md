# pack

pack -- pack and move at a moment's notice.

## Building

Use zig master. Just run

```shell
zig build
```

## Usage

### pack init

Creates an empty `.pack` file in cwd if it doesn't exist yet.

### pack add [...files]

Adds given file paths to `.pack` file.

### pack pack

Pulls the files specified in `.pack` to `store/` under current directory, preserving their paths. This repo can be committed to git.

### pack unpack

Pulls the files specified in `.pack` out of `store/` and into their original absolute paths on the system.
