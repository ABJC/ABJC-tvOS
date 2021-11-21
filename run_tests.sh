xcodebuild test \
    -workspace ABJC.xcworkspace \
    -scheme "Github Actions" \
    -sdk "appletvos15.0" \
    -destination 'platform=tvOS Simulator,OS=15.0,name=Apple TV 4K (at 1080p) (2nd generation)' \
    -enableCodeCoverage YES