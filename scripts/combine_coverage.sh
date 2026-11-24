#!/usr/bin/env bash
# Appends this package's coverage/lcov.info to $MELOS_ROOT_PATH/coverage/lcov.info (run through `melos exec`).

# The workspace root holds the combined report; deleting its coverage/ folder would lose every package appended so far.
if [ "$(pwd)" = "$MELOS_ROOT_PATH" ]; then
  exit 0
fi

escapedPath="$(echo `pwd` | sed 's/\//\\\//g')"

if grep flutter pubspec.yaml > /dev/null; then
  if [ -d "coverage" ]; then
    # combine line coverage info from package tests to a common file
    mkdir -p "$MELOS_ROOT_PATH/coverage"
    sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >> "$MELOS_ROOT_PATH/coverage/lcov.info" && rm -rf "coverage"
  fi
fi
