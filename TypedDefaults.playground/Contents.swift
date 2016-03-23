//: Playground - noun: a place where people can play

import TypedDefaults

enum Preference: String {
    case CameraConfig
    
    var key: String {
        let prefix = NSBundle.mainBundle().bundleIdentifier!
        
        return prefix + "." + self.rawValue
    }
}

struct CameraConfig: DefaultConvertible {
    enum Size: Int {
        case Large, Medium, Small
    }
    
    static let key = Preference.CameraConfig.key

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
        return ["cameraRoll": saveToCameraRoll, "size": size.rawValue]
    }
}

let memoryStore = InMemoryStore<CameraConfig>()
let anyStore = AnyStore(memoryStore)

/// set a default CameraConfig
anyStore.set(CameraConfig([:])!)

/// get CameraConfig
anyStore.get()?.saveToCameraRoll /// true
anyStore.get()?.size             /// Medium

/// remove CameraConfig
anyStore.remove()
anyStore.get()                   /// nil



