#!/bin/sh

bundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
bundleVersion=$(date "+%Y%m%d%H%M")
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundleVersion" "$INFOPLIST_FILE"