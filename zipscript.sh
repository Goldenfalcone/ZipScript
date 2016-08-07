#Shell script to inject updated files into zip files without unzipping
#Jeremy Hill 8/5/2016
#!/bin/bash

main () {
        # check we have the correct number of paramaters
        if [ $# -lt 2 ] || [ $# -gt 3 ]; then
                usage 1
        fi

        # check args 1 and 2 are full paths
        case "$1" in
        /*)
                echo "zipfile ok: $1"
                ;;
        *)
                echo "zipfile should be full path"
                exit 2
        esac

        case "$2" in
        /*)
                echo "add file ok: $2"
                ;;
        *)
                echo "add file should be full path"
                exit 2
        esac

        case "$3" in
        /*)
                echo "add path should be relative only, and not starting with . or .."
                exit 2
                ;;
        .*)
                echo "add path should be relative only, and not starting with . or .."
                exit 2
                ;;
        *)
                echo "add path ok: $3"
                ;;
        esac

        tmpdir=$(mktemp -d)
        cd "$tmpdir"
        if [ "$3" != "" ]; then
                mkdir -p "$3"
                cp "$2" "$3"
                add="$3/${2##*/}"
        else
                cp "$2" .
                add=${2##*/}
        fi

        zip -g "$1" "$add"
        cd /
        rm -rf "$tmpdir"
}

usage () {
        # print out a quick help message and exit
        cat <<EOD
Usage:
  $THISSCRIPT zipfile addfile [addpath]
This script is only for single files 
if you want multiples in a dir you need to run each one manually
You must use the full path for zipfile and addfile.  The addfile
will be added into the zipfile in path addpath.  e.g.

  $THISSCRIPT /path/to/file.zip /path/to/addfile newfiles

...will add newfiles/addfile inside file.zip

If addpath is empty, addfile will be added into the root of zipfile.

EOD

        # exit using parameter 1 as value else 0.
        exit ${1:-0}
}

# set the basename of the script for the usage message
THISSCRIPT=${0##*/}

# call the main function
main "$@"
