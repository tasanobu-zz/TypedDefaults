TypedDefaults
===

[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/TypedDefaults.svg)]()
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/tasanobu/TypedDefaults.svg?style=flat
)](https://github.com/tasanobu/TypedDefaults/issues?state=open)

`TypedDefaults` is a utility library to type-safely use NSUserDefaults.

## Motivation
The talk "Keep Calm and Type Erase On" by [Gwendolyn Weston](https://github.com/gwengrid) at [try! Swift 2016](http://www.tryswiftconf.com) is great and it inspired me to apply the technique "Type Erasure" for actual cases in app development.

## Features
- Structured data can be type-safely set/get/remove to NSUserDefaults with a single key

## Installation
- Install with Cocoapods

  ```ruby
  use_frameworks!

  platform :ios, '8.0'

  pod 'PercentEncoder'
  ```

## Requirements
- iOS 8.0+
- Swift 2.2


## Usage
- Add `import TypedDefaults` at the top of Swift file.
- Implement actual data type adopting `DefaultConvertible` protocol
  ```
  struct CameraConfig: DefaultConvertible {
      enum Size: Int {
          case Large, Medium, Small
      }

      static let key = "CameraConfig"

      let saveToCameraRoll: Bool
      let size: Size

      init?(_ object: AnyObject) {
          guard let dict = object as? [String: AnyObject] else { return nil }

          self.saveToCameraRoll = dict["cameraRoll"] as? Bool ?? true

          if let rawSize = dict["size"] as? Int, let size = Size(rawValue: rawSize) {
              self.size = size
          } else {
              self.size = .Medium
          }
      }

      func serialize() -> AnyObject {
          let obj = ["cameraRoll": saveToCameraRoll, "size": size.rawValue]
          return obj
      }
  }
  ```
- Create a `PersistentStore` instnce and pass it to `AnyStore` initializer
  ```
  let ps = PersistentStore<CameraConfig>()
  let as = AnyStore(ps)
  ```
- Call `AnyStore` methods as below
  ```
  /// Set
  var config = CameraConfig([:]) // default setting
  as.set(config)

  /// Get
  config = as.get()

  // change the config
  config.saveToCameraRoll = false
  config.size = .Large

  /// Set to save the new config in NSUserDefaults
  as.set(config)
  as.syncronize()

  /// Remove
  as.remove()
  ```

## Release Notes
See https://github.com/tasanobu/TypedDefaults/releases

## License
`TypedDefaults` is released under the MIT license. See LICENSE for details.
