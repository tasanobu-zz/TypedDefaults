//
//  TypedDefaults.swift
//  TypedDefaults
//
//  Created by Kazunobu Tasaka on 3/15/16.
//  Copyright © 2016 Kazunobu Tasaka. All rights reserved.
//

import Foundation

/// Represents objects that can type-safely be interacted with NSUserDefaults
public protocol UserDefaultsConvertible {
    
    /// Key for NSUserDefaults
    static var key: String { get }
    
    /// Desirialize AnyObject to adopted object.
    /// The argument "object" is intended to be passed from NSUserDefaults
    init?(_ object: AnyObject)
    
    /// Serialize adopted object to AnyObject for setting it to NSUserDefaults.
    func serialize() -> AnyObject
}

// MARK: -
public final class UserDefaultsWrapper<Object: UserDefaultsConvertible> {
    private let _type: Object.Type
    
    private let ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    public init(type: Object.Type) {
        _type = type
    }
    
    public func getObject() -> Object? {
        guard let obj = ud.objectForKey(Object.key) else { return nil }
        return Object(obj)
    }
    
    public func setObject(object: Object) {
        let obj = object.serialize()
        let key = Object.key
        
        ud.setObject(obj, forKey: key)
    }
    
    public func removeObject() {
        ud.removeObjectForKey(Object.key)
    }
}

