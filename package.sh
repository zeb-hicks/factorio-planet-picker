#!/bin/bash
CWD=$(pwd)

# Name of the zip archive
NAME="$(basename "$PWD")"
ZIP_FILE="$NAME.zip"

# Create a temporary file to store the list of files to include in the zip
INCLUDE_FILE=$(mktemp)

# Change to the parent working directory
cd ..

# Generate the list of files to include in the zip, ignoring patterns in .gitignore
find $NAME -type f | grep -v -f $NAME/.zipignore > "$INCLUDE_FILE"

# Create the zip archive
zip -r "$ZIP_FILE" -@ < "$INCLUDE_FILE"

# Remove the temporary file
rm "$INCLUDE_FILE"

echo "Archive created: $ZIP_FILE"

cd "$CWD"