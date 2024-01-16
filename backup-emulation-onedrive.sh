#! /usr/bin/bash

# Backup emulation folder with roms and bios to onedrive with rclone preconfigured

# display help
function print_help {
    echo "Usage: $0 -s <source-dir> -r <root-remote> -t <target-remote>"
    echo "   -s, --source-dir     Local source directory"
    echo "   -r, --root-remote    Root for remote (default: 'onedrive:')"
    echo "   -t, --target-remote  Target for remote"
    exit 1
}

# default for onedrive root-remote
ROOT_REMOTE=onedrive:

# Get local-source and onedrive-target
VALID_ARGS=$(getopt -o hs:r:t: --long help,source-dir:,root-remote:,target-remote: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi 

eval set -- "$VALID_ARGS"
while true; do
    case "$1" in
        -h | --help)
            print_help
            ;;
        -s | --source-dir)
            SOURCE_DIR=$2
            echo "local source directory: $SOURCE_DIR"
            shift 2
            ;;
        -r | --root-remote)
            ROOT_REMOTE=$2
            echo "Root for remote: $ROOT_REMOTE"
            shift 2
            ;;
        -t | --target-remote)
            TARGET_REMOTE=$2
            echo "target for remote: $TARGET_REMOTE"            
            shift 2
            ;;
        --)
            shift
            break
            ;;
    esac
done

# validate paths and backup
TARGET_FULL=$ROOT_REMOTE$TARGET_REMOTE
echo "Full path for target remote: $TARGET_FULL"

if [[ ! -e $SOURCE_DIR ]]; then
    echo "Source '$SOURCE_DIR' does not exists."
    exit 1
fi
if ! rclone lsd $ROOT_REMOTE >/dev/null 2>&1; then
    echo "Remote $ROOT_REMOTE does not exists or can't be accessed with rclone."
    exit 1
elif ! rclone lsd $TARGET_FULL >/dev/null 2>&1; then
    echo "Remote $TARGET_FULL does not exists or can't be accessed with rclone."
    exit 1
else
    # Use rclone to sync emulation folder with symbolic links
    echo "Performing: rclone sync -LP $SOURCE_DIR $TARGET_FULL..."
    rclone sync -LP $SOURCE_DIR $TARGET_FULL
fi

# Log if errors
if [ $? -eq 0 ]; then
    echo "Backup of $SOURCE_DIR to $ROOT_REMOTE successful!"
    exit 0
else
    echo "Some error(s) occurred during backup from $SOURCE_DIR to $ROOT_REMOTE. See logs from rclone."
fi

