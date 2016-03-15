//
//  TypedDefaults.swift
//  TypedDefaults
//
//  Created by Kazunobu Tasaka on 3/15/16.
//  Copyright © 2016 Kazunobu Tasaka. All rights reserved.
//

import Foundation

/// Represents objects that can type-safely be interacted with NSUserDefaults
protocol UserDefaultsConvertible {
    
    /// Key for NSUserDefaults
    static var key: String { get }
    
    /// Desirialize AnyObject to adopted object.
    /// The argument "object" is intended to be passed from NSUserDefaults
    init?(_ object: AnyObject)
    
    /// Serialize adopted object to AnyObject for setting it to NSUserDefaults.
    func serialize() -> AnyObject
}

// MARK: -
final class UserDefaultsWrapper<Object: UserDefaultsConvertible> {
    class func get() -> Object? {
        guard let obj = NSUserDefaults.standardUserDefaults().objectForKey(Object.key) else {
            return nil
        }
        return Object(obj)
    }
    class func set(object: Object) {
        let obj = object.serialize()
        let key = object.dynamicType.key
        NSUserDefaults.standardUserDefaults().setObject(obj, forKey: key)
    }
    class func remove() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Object.key)
    }
}

