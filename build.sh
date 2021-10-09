output_dir=$(pwd)

if [ -d $1 ]; then
    output_dir=$1
fi

rm -r archives

xcodebuild archive \
    -scheme MoyasarSdk \
    -sdk iphoneos \
    -archivePath "archives/ios_devices.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

xcodebuild archive \
    -scheme MoyasarSdk \
    -sdk iphonesimulator \
    -archivePath "archives/ios_simulators.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

rm -r $output_dir/MoyasarSdk.xcframework

xcodebuild -create-xcframework \
    -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/MoyasarSdk.framework \
    -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/MoyasarSdk.framework \
    -output $output_dir/MoyasarSdk.xcframework
