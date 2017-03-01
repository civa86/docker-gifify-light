# gifify-light

Light Docker Container to convert videos in animated GIFs.

## Usage

Install [docker](https://www.docker.com/) in your system.
 
```bash
docker run -v $(pwd):/data civa86/gifify-light [options] [files] ...
```  

`[files]`: list files you want to convert. Each file must be present under shared /data folder. 
 
## Options

```bash
-w, --width               output image width
-h, --height              output image height
```
