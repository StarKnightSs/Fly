#!/bin/sh

#  SwiftFormat.sh
#  Fly
#
#  Created by Arpit Williams on 15/05/24.
#  

echo "RUNNING SWIFTFORMAT"

# Format only changed files if input files are not emtpy
(git diff --diff-filter=d --cached --name-only; git diff --diff-filter=d --name-only) | grep -e '\(.*\).swift$' > .inputFiles
if [ -s .inputFiles ]; then
  xcrun --sdk macosx swift run --package-path BuildTools swiftformat --swiftversion 5.9 --filelist .inputFiles
else
  echo "INPUT FILES EMPTY"
fi
rm .inputFiles
