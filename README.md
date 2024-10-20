
# Moyasar iOS SDK

The Moyasar iOS SDK provides a streamlined way to integrate Moyasar's payment solutions into your iOS applications. With support for CocoaPods, Swift Package Manager (SPM), and manual integration, developers have flexibility in how they incorporate the SDK into their projects.

## Installation

You can integrate the Moyasar SDK into your project using one of the following methods:

### 1. CocoaPods

1. Add the following line to your `Podfile`:
    ```ruby
    pod 'MoyasarSdk', git: 'https://github.com/moyasar/moyasar-ios-pod.git'
    ```
2. Install the dependency:
    ```sh
    pod install
    ```

### 2. Swift Package Manager (SPM)

Swift Package Manager (SPM) is a tool for managing the distribution of Swift code. Starting from version 1.0.5, the Moyasar SDK supports integration via SPM. Here’s how you can add it to your project:

1. In Xcode, open your project and navigate to the project settings.
2. Select your target, then go to the "Package Dependencies" tab.
3. Click the "+" button to add a new package.
4. In the package repository URL field, enter:
    ```
    https://github.com/moyasar/moyasar-ios-sdk.git
    ```
5. Choose the branch `master`.

For more details, refer to the [official documentation](https://docs.mysr.dev/sdk/ios/installation).

## Migration from v2.0.1 to v3.0.0

To migrate from version 2.0.1 to 3.0.0, please follow the [migration guide](https://docs.mysr.dev/sdk/ios/installation).

### Using Older Versions

#### CocoaPods
To use an older version, add the tag for it like this:
```ruby
pod 'MoyasarSdk', :git => 'https://github.com/moyasar/moyasar-ios-pod.git', :tag => 'v1.0.5'
```

#### Swift Package Manager (SPM)
You can specify the versioning in SPM as flow:

- For version 2.0.1:
  ```plaintext
  https://github.com/moyasar/moyasar-ios-sdk.git, version: 2.0.1
  ```

By following these steps, you can easily integrate and migrate the Moyasar iOS SDK into your project. For any further details and documentation, visit [Moyasar's official documentation](https://docs.mysr.dev/sdk/ios/installation).


## APIs Documentation

* <https://moyasar.github.io/moyasar-ios-sdk/documentation/moyasarsdk>

## Migration Guide

### From `0.4` to `1.0`

* <https://docs.moyasar.com/ios-sdk#Lxmx0>
