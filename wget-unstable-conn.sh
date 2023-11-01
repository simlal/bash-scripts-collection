#! /usr/bin/bash

# Default target dir
target-directory="."

# Parse cli options
while getops ":P:" flag
do 
    case "${flag}" in
        P) prefix-dir=${OPTARG};;
    esac
done

# Remove parsed options from cli arguments + assign url
shift $((OPTIND -1))
url=$1

# Help msg when url not provided
if [[ -z "$url" ]]; then
    echo "Usage: wget-download-optimal.sh [-P prefix-dir] url"
    exit 1
else
    # Download file with optimisations for slow / unstable connections
    wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 -P $prefix-dir $url
    exit 0
fi
