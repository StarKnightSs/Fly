#!/bin/sh

#  SwiftFormat.sh
#  Fly
#
#  Created by Arpit Williams on 15/05/24.
#  

echo "RUNNING SWIFTFORMAT"
xcrun --sdk macosx swift run --package-path BuildTools swiftformat --swiftversion 5.9 FlyApp FlyKit FlyTests FlyUITests
