//
//  TypedDefaults.swift
//  TypedDefaults
//
//  Created by Kazunobu Tasaka on 3/15/16.
//  Copyright © 2016 Kazunobu Tasaka. All rights reserved.
//

import Foundation

// MARK: - DefaultConvertible

/// Represents objects that can type-safely be interacted with DefaultStoreType
public protocol DefaultConvertible {
    
    static var key: String { get }
    
    /// Desirialize AnyObject to adopted object.
    /// The argument "object" is intended to be passed from DefaultStoreType
    init?(_ object: AnyObject)
    
    /// Serialize adopted object to AnyObject for setting it to DefaultStoreType.
    func serialize() -> AnyObject
}

// MARK: - DefaultStoreType

public protocol DefaultStoreType {
    
    associatedtype Default: DefaultConvertible
  
    func set(value: Default)
    func get() -> Default?
    func remove()
}

// MARK: -

public final class AnyStore<D: DefaultConvertible>: DefaultStoreType {
    
    public typealias Default = D
    
    private let _set: Default -> ()
    private let _get: () -> Default?
    private let _remove: () -> ()
    
    public init<Inner: DefaultStoreType where Inner.Default == D>(_ inner: Inner) {
        _set = inner.set
        _get = inner.get
        _remove = inner.remove
    }
    
    public func set(value: Default) {
        _set(value)
    }
    
    public func get() -> Default? {
        return _get()
    }
    
    public func remove() {
        _remove()
    }
}

// MARK: -

public final class DefaultsStore<Default: DefaultConvertible>: DefaultStoreType {
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    public func set(value: Default) {
        let obj = value.serialize()
        defaults.setObject(obj, forKey: Default.key)
    }
    
    public func get() -> Default? {
        guard let obj = defaults.objectForKey(Default.key) else { return nil }
        return Default(obj)
    }
    
    public func remove() {
        defaults.removeObjectForKey(Default.key)
    }
}

// MARK: -

public final class DictionaryStore<Default: DefaultConvertible>: DefaultStoreType {
    
    private var dictionary: [String: AnyObject] = [:]
    
    public func set(value: Default) {
        let obj = value.serialize()
        dictionary[Default.key] = obj
    }
    
    public func get() -> Default? {
        guard let obj = dictionary[Default.key] else { return nil }
        return Default(obj)
    }
    
    public func remove() {
        dictionary[Default.key] = nil
    }
}
