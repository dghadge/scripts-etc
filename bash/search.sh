#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage : ./search.sh searchTerm1|phrase1 searchTerm2|phrase2"
    exit 0
fi

searchstring=$1".*"$2

for file in `ls`
do
    if [ -f "$file" ]; then
        awk -v RS="\0777" -v pattern="$searchstring" 'tolower($0) ~ tolower(pattern) {print "Pattern found in file: "FILENAME}' $file
    fi
done
