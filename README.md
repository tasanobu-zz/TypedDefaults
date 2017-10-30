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

#### Motivation
The talk *[Keep Calm and Type Erase On](https://realm.io/news/tryswift-gwendolyn-weston-type-erasure/)* by [Gwendolyn Weston](https://github.com/gwengrid) at [try! Swift 2016](http://www.tryswiftconf.com) is great and it inspired me to apply the technique *Type Erasure* for actual cases in app development.

#### Installation
- Install with CocoaPods

  ```ruby
  use_frameworks!

  platform :ios, '8.0'

  pod 'TypedDefaults'
  ```

#### Requirements
- iOS 8.0+
- Swift 4.0
- Xcode 9

## Features
- Custom types can be type-safely stored in NSUserDefaults
- Dependency Injection support

## Usage

### Custom types
Custom types can be type-safely stored in NSUserDefaults.<br/>
Custom types only need to adopt `DefaultsConvertible` protocol as described later. No need to inherit NSObject.<br/>
Therefore, `Swift native Class` `Struct` and `Enum` are available for custom types.(Of course, subclasses of NSObject are available.)  

#### `DefaultsConvertible` protocol
```swift
public protocol DefaultConvertible {

    static var key: String { get }

    init?(_ object: Any)

    func serialize() -> Any
}
```

Custom types are stored in NSUserDefaults as AnyObject.<br/>
`serialize()` is called when saving and `init?(_ object:)` is called when getting from NSUserDefaults.<br/>
<br/>
It's assuemd each custom type and one configuration used in app is one-to-one relation.<br/>
Therefore, `key` is prepared as type property in order to assign `key` to one `custom type`.

##### Example of custom type
This is an example of the custom type with `flag for saving photo to CameraRoll` and `Photo Size` as camera configuration.

```swift
struct CameraConfig: DefaultConvertible {
    enum Size: Int {
        case Large, Medium, Small
    }

    var saveToCameraRoll: Bool
    var size: Size

    // MARK: DefaultConvertible

    static let key = "CameraConfig"

    init?(_ object: Any) {
        guard let dict = object as? [String: Any] else {
          return nil
        }

        self.saveToCameraRoll = dict["cameraRoll"] as? Bool ?? true
        if let rawSize = dict["size"] as? Int,
         let size = Size(rawValue: rawSize) {
            self.size = size
         } else {
            self.size = .Medium
        }
    }

    func serialize() -> Any {
        return ["cameraRoll": saveToCameraRoll, "size": size.rawValue]
    }
}
```

#### Saving custom type to NSUserDefaults
`PersistentStore` is the class to save custom types to NSUserDefaults.<br/>
Below is the sample of how to use it.

```swift
/// Specify a custom type when initializing PersistentStore
let userDefaults = PersistentStore<CameraConfig>()

// Make an instance of CameraConfig
var cs = CameraConfig([:])!

// Set
userDefaults.set(cs)
// Get
userDefaults.get()?.size // Medium

/// Change the size
cs.size = .Large

// Set
userDefaults.set(cs)
// Get
userDefaults.get()?.size // Large
```

### Dependency Injection support
NSuserDefaults is not Unit Test friendly because it persistently stores data on file system.<br/>
`TypedDefaults` has the types `InMemoryStore` `AnyStore` for Dependency Injection in order to test types which behave differently depending on custom types stored in NSuserDefaults.<br/>
<br/>
`InMemoryStore` adopts `DefaultStoreType` protocol as well as `PersistentStore`. <br/>
However, `InMemoryStore` retains custom types only on memory, which is different from `PersistentStore`.<br/>
As for `AnyStore`, it is the type to abstract `PersistentStore` and `InMemoryStore`.

#### Example
This is the example to use `InMemoryStore` and `AnyStore` instead of `PersistentStore` at Unit Test.<br/>
<br/>
There is a class called `CameraViewController` which inherits UIViewController.<br/>
It has a property `config` to retain a custom type saved in NSuserDefaults. To support Dependency Injection, set `AnyStore` as the type of `config`.

```
class CameraViewController: UIViewController {
    lazy var config: AnyStore<CameraConfig> = {
        let ds = PersistentStore<CameraConfig>()
        return AnyStore(ds)
    }()

    ...
}
```

Because the type of `config` is not `PersistentStore` but `AnyStore`, it can be replaced with `InMemoryStore` at Unit Test as below.

```
class CameraViewControllerTests: XCTestCase {
    var viewController: CameraViewController!

    override func setUp() {
        viewController = CameraViewController()

        let defaultConfig = CameraConfig([:])!
        let ds = InMemoryStore<CameraConfig>()
        ds.set(defaultConfig) //
        viewController.config = AnyStore(ds)
    }
}
```

## Release Notes
See https://github.com/tasanobu/TypedDefaults/releases

## License
`TypedDefaults` is released under the MIT license. See LICENSE for details.
