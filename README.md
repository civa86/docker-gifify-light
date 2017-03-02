# gifify-light

Light Docker Container to convert videos in animated GIFs.

## Usage

Install [docker](https://www.docker.com/) in your system.

```bash
docker run -v $(pwd):/data civa86/gifify-light [options] [files]
```

`[files]`: list files you want to convert, space separated.

Each file must be present under shared /data, shared with -v docker option

## Options

Options are valid for all `[files]`

```bash
-w, --width         output images width
-h, --height        output images height
```
