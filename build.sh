#!/bin/bash

# stop script if one of the commands return a non-0 error code
set -e

echo "Updating node_modules"
npm ci

echo "Building Extensions"
npm run build

rm -f build/chrome.manifest.json
rm -f build/firefox.manifest.json

echo "Building Chrome zip."
cp public/chrome.manifest.json build/manifest.json
version=$(cat build/manifest.json | jq -r '.version')
zip -r "chrome-extension-$version.zip" build/ > /dev/null

echo "Building Firefox zip."
cp public/firefox.manifest.json build/manifest.json
version=$(cat build/manifest.json | jq -r '.version')
zip -r "firefox-extension-$version.zip" build/* > /dev/null

# put files back in the right position
cp public/chrome.manifest.json build/chrome.manifest.json
cp public/firefox.manifest.json build/firefox.manifest.json

echo "DONE!"
