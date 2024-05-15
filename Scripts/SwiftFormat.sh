#!/bin/sh

#  SwiftFormat.sh
#  Fly
#
#  Created by Arpit Williams on 15/05/24.
#  

echo "RUNNING SWIFTFORMAT"
swift run --package-path BuildTools swiftformat --swiftversion 5.0 FlyApp FlyKit FlyTests FlyUITests --indent 2 --disable trailingCommas,redundantGet,redundantBackticks,unusedArguments,blankLinesAtStartOfScope,elseOnSameLine,redundanttype,wrapArguments,wrapAttributes,wrapMultilineStatementBraces,extensionAccessControl,enumNamespaces,redundantParens,hoistTry,redundantSelf,redundantReturn
