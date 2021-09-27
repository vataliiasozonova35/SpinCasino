#!/bin/bash

set -eo pipefail

xcodebuild -workspace SpinCasino.xcworkspace \
            -scheme SpinCasino \
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/SpinCasino.xcarchive \
            clean archive | xcpretty
