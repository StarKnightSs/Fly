#!/bin/sh

#  SwiftLint.sh
#  Fly
#
#  Created by Arpit Williams on 15/05/24.
#

echo "RUNNING SWIFTLINT"
swift run --package-path BuildTools swiftlint
