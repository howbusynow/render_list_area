#!/bin/sh

usage="Usage: $(basename "$0") [OPTION...] DATA_FILE_1 [DATA_FILE_2 ...]
OPTIONS:
  -f, --force          render tiles even if they seem current
  -m, --map=MAP        render tiles in this map (defaults to render_list default)
  -l, --max-load=LOAD  sleep if load is this high (defaults to render_list default)
  -s, --socket=SOCKET  unix domain socket name for contacting renderd (defaults to render_list default)
  -n, --num-threads=N the number of parallel request threads (defaults to render_list default)
  -t, --tile-dir       tile cache directory (defaults to render_list default)
  -z, --min-zoom=ZOOM  filter input to only render tiles greater or equal to this zoom level (default is 0)
  -Z, --max-zoom=ZOOM  filter input to only render tiles less than or equal to this zoom level (default is 20)

DATA_FILE:
  Each line in the file describes an area to import using geographic coordinates (WGS84) and an optional label for the log:

      <START_LONGITUDE> <START_LATITUDE> <END_LONGITUDE> <END_LATITUDE> [LABEL]

  - Fields separated by space 
  - Terminate file with empty line, or the last area in the file will not be processed."

FILES=""
while (( "$#" )); do
  case "$1" in
    -f|--force)
      FORCE="$FLAGS -f"
      shift
      ;;
    -m|--map)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        FLAGS="$FLAGS -m $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -l|--max-load)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        FLAGS="$FLAGS -l $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -s|--socket)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        FLAGS="$FLAGS -s $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -n|--num-threads)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        FLAGS="$FLAGS -n $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -t|--tile-dir)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        FLAGS="$FLAGS -t $2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -z|--min-zoom)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MIN_ZOOM="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -Z|--max-zoom)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MAX_ZOOM="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        echo "$usage" >&2
        exit 1
      fi
      ;;
    -\?|--help)
      echo "$usage"
      exit 0
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      FILES="$FILES $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$FILES"

CMD="./render_list_geo.pl $FLAGS -z ${MIN_ZOOM:-0} -Z ${MAX_ZOOM:-20}"

echo `date` "STARTING"
for FILE in $FILES
do
    # If file exists 
    if [[ -f "$FILE" ]]
    then
        # read it
        while IFS=' ' read -r x y X Y label
        do
            # display $line or do something with $line
            echo `date` "*** Starting ${label:-area}"
            echo $CMD -x $x -y $y -X $X -Y $Y
            echo `date` "*** Finished ${label:-area}"
            echo
        done <"$FILE"
    else
        echo "Input file not found: $FILE"
    fi
done
echo `date` "FINISHED"