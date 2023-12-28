output_dir=$(pwd)

if [ -n "$1" ]; then
    desired_xcode_sdk_path=$1
else
    echo "Specify the path to the desired Xcode SDK to build this SDK (E.x: /Applications/Xcode_14.3.1.app/Contents/Developer/usr/bin)"
    echo "Documentation of this SDK will be built with the default Xcode because it will not affect the shipped framework and it's better to build it with the latest Xcode version"
    exit 1
fi

if [ -d "$2" ]; then
    output_dir=$2
else 
    echo "Will use $output_dir as the default output path"
fi

rm -r archives

$desired_xcode_sdk_path/xcodebuild archive \
    -scheme MoyasarSdk \
    -sdk iphoneos \
    -archivePath "archives/ios_devices.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

$desired_xcode_sdk_path/xcodebuild archive \
    -scheme MoyasarSdk \
    -sdk iphonesimulator \
    -archivePath "archives/ios_simulators.xcarchive" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SKIP_INSTALL=NO

rm -r $output_dir/MoyasarSdk.xcframework

$desired_xcode_sdk_path/xcodebuild -create-xcframework \
    -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/MoyasarSdk.framework \
    -framework archives/ios_simulators.xcarchive/Products/Library/Frameworks/MoyasarSdk.framework \
    -output $output_dir/MoyasarSdk.xcframework

xcodebuild docbuild \
    -scheme MoyasarSdk \
    OTHER_DOCC_FLAGS='--transform-for-static-hosting 
		--hosting-base-path moyasar-ios-sdk 
		--output-path ../docs'
