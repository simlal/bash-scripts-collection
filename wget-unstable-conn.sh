#! /usr/bin/bash

# Default target dir
target-directory="."

# Parse cli options
while getops ":t:" flag
do 
    case "${flag}" in
        t) target-dir=${OPTARG};;
    esac
done

# Remove parsed options from cli arguments + assign url
shift $((OPTIND -1))
url=$1

# Help msg when url not provided
if [[ -z "$url" ]]; then
    echo "Usage: wget-download-optimal.sh [-t target-directory] url"
    exit 1
else
    # Download file with optimisations for slow / unstable connections
    wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 -P $target-dir $url
    exit 0
fi