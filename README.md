# render_list_areas

## render_list_areas.sh

Utility script to 'pre-render' areas of OSM map.

### Usage:
    ./render_list_areas.sh [OPTION...] DATA_FILE_1 [DATA_FILE_2 ...]
    OPTIONS:
    -f, --force          render tiles even if they seem current
    -m, --map=MAP        render tiles in this map (defaults to render_list default)
    -l, --max-load=LOAD  sleep if load is this high (defaults to render_list default)
    -s, --socket=SOCKET  unix domain socket name for contacting renderd (defaults to render_list default)
    -n, --num-threads=N the number of parallel request threads (defaults to render_list default)
    -t, --tile-dir       tile cache directory (defaults to render_list default)
    -z, --min-zoom=ZOOM  filter input to only render tiles greater or equal to this zoom level (default is 0)
    -Z, --max-zoom=ZOOM  filter input to only render tiles less than or equal to this zoom level (default is 20)

## Data file:
Each line in the file describes an area to import using geographic coordinates (WGS-84) and an optional label for the log:

    <START_LONGITUDE> <START_LATITUDE> <END_LONGITUDE> <END_LATITUDE> [LABEL]

- Fields separated by space 
- LABEL field is optional and may contain spaces. It's only used in the logs.
- **NOTE:** The file should end with anempty line. Otherwise the last area in the file will not be processed (it's a bash thing).

You can get the bounding box coordinates from [Geofabrik's Tile Calculator](http://tools.geofabrik.de/calc/) simply select the area you are interested in and copy the `Simple Copy` coordinates from the Coordinate Display (CD) tab. Make sure to use `EPSG:4326` projection.

### Please Note
The coordinates in the Data files do not represent any sort of official boundary. You should define your own data files if these don't work for you.

## render_list_geo.pl
The underlying perl script (render_list_geo.pl) was forked from [render_list_geo.pl](https://github.com/alx77/render_list_geo.pl) and is included for convenience. Kudos to [alx77](https://github.com/alx77).

Perl script for automatic rendering OSM tiles for renderd+mod_tile with using geographic coordinates (WGS-84)



### Usage:
    ./render_list_geo.pl -n <n> -s <s> -t <t> -z <z> -Z <Z> -x <x> -X <X> -y <y> -Y <Y>
    where:
    <n> - number of concurrent threads
    <l> - maximum load
    <m> - render tiles from this map
    <s> - socket for renderd
    <t> - tiles location
    <z> - render tiles from this zoom level
    <Z> - render tiles to this zoom level
    <x> - render tiles from this longitude
    <X> - render tiles to this longitude
    <y> - render tiles from this latitude
    <Y> - render tiles to this latitude
