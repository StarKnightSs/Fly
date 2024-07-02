#!/bin/zsh

#  ci_post_clone.sh
#  Fly
#
#  Created by Arpit Williams on 03/07/24.
#  

set -e
echo "TRUSTING MACROS"
mkdir -p ~/Library/org.swift.swiftpm/security/
cp macros.json ~/Library/org.swift.swiftpm/security/
exit 0
