#!/bin/sh

#  SwiftLint.sh
#  Fly
#
#  Created by Arpit Williams on 15/05/24.
#

echo "RUNNING SWIFTLINT"

# Lint only changes files
(git diff --diff-filter=d --cached --name-only; git diff --diff-filter=d --name-only) | grep -e '\(.*\).swift$' | while read file; do
  xcrun --sdk macosx swift run --package-path BuildTools swiftlint "${file}"
done
