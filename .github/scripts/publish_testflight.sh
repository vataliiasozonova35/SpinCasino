#!/bin/bash

set -eo pipefail

xcrun altool --upload-app -t ios -f build/SpinCasino.ipa -u "$ACC" -p "$PASS" --verbose
