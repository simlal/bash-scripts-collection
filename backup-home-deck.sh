#!/bin/bash

# Backup whole /home/deck to a usb drive using rsync

function print_help {
    echo "Usage: $0 -s <source-dir> -t <target-dir>"
    echo "   -s, --source-dir     Local source directory to backup from."
    echo "   -t, --target-dir     Target directory to make the backup to."
    exit 1
}

# Validate local-to-backup and target dirs
VALID_ARGS=$(getopt -o hs:t: --long help,source-dir:,target-dir: -- "$@")
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
        -t | --target-dir)
            TARGET_DIR=$2
            echo "Target directory: $TARGET_DIR"
            shift 2
            ;;
        --)
            shift
            break
            ;;
    esac
done
# define source and targets
# example_home="/home/deck/"
# example_target="/run/media/deck/VS Passport/backup-steam-deck-home/backup-home-deck-post-roms/"
# exclude1=".steam/steam/steamapps/common"
# exclude2='Emulation'

echo "Validating paths:"
echo -e "\tsource_dir=$source_dir"
echo -e "\ttarget_dir=$target_dir"
# echo -e "\texclusion_1=$exclude1\n"

# validate paths and run rsync
if [[ ! -e "$source_dir" ]]; then
    echo "Source '$source_dir' does not exists."
    exit 1
elif [[ ! -e "$target_dir" ]]; then
    echo "Target directory '$target_dir' does not exists."
    exit 1
# elif [[ ! -e  "$source_dir$exclude1" ]]; then
    echo "Exclusion '$exclude1' does not exists."
    exit 1
# elif [[ ! -e $exclude2 ]]; then
#     echo "Exclusion '$exclude2' does not exists."
#     exit 1
else
    echo "rsync -aAX --info=progress2 --delete $source_dir $target_dir"
    rsync -aAX --info=progress2 --delete "$source_dir" "$target_dir"
fi

# Log if errors
if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
    exit 0
else
    echo "Some error occurred during backup. See previous output from rsync."
    exit
fi
