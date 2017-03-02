#!/bin/sh

WIDTH=""
HEIGHT=""
VIDEOS=""

function set_width () {
    local W=${1/'-w='/''}
    W=${W/'--width='/''}
    WIDTH=$W
}

function set_height () {
    local H=${1/'-h='/''}
    H=${H/'--height='/''}
    HEIGHT=$H
}

function read_input () {
    if test $# -eq 0; then
      echo "No video to process. Usage..."
      exit 1
    else
      while test $# -ne 0; do
        case $1 in
          -w=*|--width=*) set_width $1 ;;
          -h=*|--height=*) set_height $1 ;;
          *) VIDEOS="$VIDEOS;$1" ;;
        esac
        shift
      done
    fi
}

function convert_videos () {
    IFS=";"
    for v in $VIDEOS
    do
        if [ ! -f $v ]
        then
            echo "File $v not found in $PWD"
            exit 1
        fi

        if [[ ! -z $v ]]
        then
            eval $(ffprobe -v error -of flat=s=_ -select_streams v:0 -show_entries stream=height,width $v)

            local OUT_W=""
            local OUT_H=""
            local VIDEO_W=${streams_stream_0_width}
            local VIDEO_H=${streams_stream_0_height}
            local FILENAME=$(basename "$v")
            local DIRNAME=$(dirname "$v")
            local RATIO=`echo "scale=2; $VIDEO_W/$VIDEO_H" | bc -l`

            FILENAME="${FILENAME%.*}"

            if [[ ! -z $WIDTH ]] && [[ ! -z $HEIGHT  ]]
            then
                OUT_W=$WIDTH
                OUT_H=$HEIGHT
            elif [[ ! -z $WIDTH ]]
            then
                OUT_W=$WIDTH
                OUT_H=$WIDTH
            elif [[ ! -z $HEIGHT ]]
            then
                OUT_W=`echo "scale=0; ($HEIGHT*$RATIO)/1" | bc -l`
                OUT_H=$OUT_W
            else
                OUT_W=$VIDEO_W
                OUT_H=$VIDEO_W
            fi

            echo "------------------------------"
            echo "GIFIFY :: processing $v"
            echo "------------------------------"
            sleep 1
            ffmpeg -i $v -r 10 -vcodec png /tmp/out-static-%05d.png
            time convert -verbose +dither -layers Optimize -resize $OUT_Wx$OUT_H\> /tmp/out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $DIRNAME/$FILENAME.gif
            rm /tmp/out-static*.png

            echo "------------------------------"
            echo "            FINISH"
            echo "------------------------------"

        fi
    done
}

read_input $@
convert_videos
