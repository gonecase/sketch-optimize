#!/bin/bash

# BASE OPTIONS
if [ ! -z $1 ]; then
    :
    SKETCHFILE="$1"
else
    :
    echo ""
    echo "no sketchfile provided"
    echo ""
    echo ""
    echo "SYNTAX :"
    echo ""
    echo ". sketchoptim.sh path/to/sketchfile max_width_in_px"
    echo ""
    echo "example :"
    echo ". sketchoptim.sh mysketchfile.sketch 1400"
    return
fi

if [ ! -z $2 ]; then
    :
    MAXWIDTH="$2"
else
    :
    MAXWIDTH=1440
    echo ""
    echo "No max width provided. Defaulting to 1440px."
    echo ""
fi

if [ -f "$SKETCHFILE" ]; then
    echo "File exists!"
    echo ""
    FILE_EXT=$(awk -F'.' '{print $NF}' <<< $SKETCHFILE)
    MIMETYPE=$(file --mime-type -b $SKETCHFILE)
    if [ $FILE_EXT == "sketch" ] && [ $MIMETYPE == "application/zip" ] 
    then
        echo "FILE VALID"
    else
        echo "FILE INVALID"
        return
    fi

    # # Handling the export
    say -v veena  "File type and mime type are valid." && say -v veena  " beginning processing.."
    # echo ""
    say -v veena "Creating temp directory"
    cd ~
    mkdir __temp_sketchoptimizer
    cd __temp_sketchoptimizer
    cp "$SKETCHFILE" .
    open .
    THEFILE=$(basename "$SKETCHFILE")
    OUTPUT="filename : $SKETCHFILE • Max width $MAXWIDTH"
    say -v veena "processing $THEFILE"
    unzip "$THEFILE"
    rm "$THEFILE"
    cd images
    say -v veena "Optimizing assets"
    sips -Z "$MAXWIDTH" *
    cd ..
    say -v veena "creating optimized sketchfile"
    zip -r "optimized.$THEFILE" *
    mv "optimized.$THEFILE" ~/Desktop
    cd ..
    rm -rf __temp_sketchoptimizer
    say -v veena "optimized file is on your desktop!"
    return
else
    echo "File not found."
    echo ""
    return
fi

# FILESIZE="$2"
echo " $SKETCHFILE $MAXWIDTH"
