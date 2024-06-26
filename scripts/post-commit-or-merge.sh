#!/bin/sh
DATA_DIR="Data"
OUTPUT_DIR="output"
SOURCE_DIR="xml-data-source"
SOURCE_DIR_LENGTH=$(expr length "$SOURCE_DIR/")
TOOLS_DIR="tools"
HEAD_COMMIT=`git rev-parse HEAD`

LATEST_BAR_LINE=`ls -lh "$OUTPUT_DIR" | grep "Data_latest.bar"`
if echo "$LATEST_BAR_LINE" | grep -E "^l"; then
    while read -r -a columns; do
        for column in "${columns[@]}"; do
            ORIGIN_BAR="$column"
        done
    done <<< "$LATEST_BAR_LINE"

    if [ -n "$ORIGIN_BAR" ]; then
        ORIGIN_HASH=`echo "$ORIGIN_BAR" | cut -d'_' -f2 | cut -d'.' -f1`
        if [ "$ORIGIN_HASH" != "$HEAD_COMMIT" ]; then
            rm -f "$OUTPUT_DIR/Data_$ORIGIN_HASH.bar"
        fi
    fi
fi

echo "git hash from origin file: $ORIGIN_HASH"
if [ -n "$ORIGIN_HASH" ]; then
    FILE_FILTER=
    FILE_COUNT=0
    TEMP_FILE="tmp.tmp"
    rm -f "$TEMP_FILE"
    git diff --name-status HEAD "$ORIGIN_HASH" | grep -v '^D' | grep "$SOURCE_DIR/" | sort | uniq > "$TEMP_FILE"
    cat "$TEMP_FILE"

    while read -a columns; do
        MODIFIED_FILE=
        for column in "${columns[@]}"; do
            MODIFIED_FILE="$column"
        done
        RELATIVE_PATH=${MODIFIED_FILE:$SOURCE_DIR_LENGTH}

        FILE_FILTER="$FILE_FILTER filter=$RELATIVE_PATH"
        ((FILE_COUNT++))
    done < "$TEMP_FILE"

    rm -f "$TEMP_FILE"

    if [ $FILE_COUNT -gt 16 ]; then
        FILE_FILTER=""
    fi;
fi

echo "$TOOLS_DIR/aoe3-auto-packager.exe source="$SOURCE_DIR" data="$DATA_DIR" suffix="$HEAD_COMMIT" "$FILE_FILTER""
$TOOLS_DIR/aoe3-auto-packager.exe source="$SOURCE_DIR" data="$DATA_DIR" suffix="$HEAD_COMMIT" "$FILE_FILTER"
mv "Data_$HEAD_COMMIT.bar" "$OUTPUT_DIR/Data_$HEAD_COMMIT.bar"

rm -f "$OUTPUT_DIR/Data_latest.bar"

cd "$OUTPUT_DIR"
cmd.exe /C "mklink "Data_latest.bar" "Data_$HEAD_COMMIT.bar""
