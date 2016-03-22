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
    
    /// Desirialize AnyObject to adopted object.
    /// The argument "object" is intended to be passed from DefaultStoreType
    init?(_ object: AnyObject)
    
    /// Serialize adopted object to AnyObject for setting it to DefaultStoreType.
    func serialize() -> AnyObject
}

// MARK: - DefaultStoreType

public protocol DefaultStoreType {
    associatedtype Default: DefaultConvertible
    
    var key: String { get }
    
    init(type: Default.Type, key: String)
    
    func set(value: Default)
    func get() -> Default?
    func remove()
}

// MARK: -

public final class AnyStore<D: DefaultConvertible>: DefaultStoreType {
    public typealias Default = D
    
    public let key: String
    
    private let _set: Default -> ()
    private let _get: () -> Default?
    private let _remove: () -> ()
    
    public init<Inner: DefaultStoreType where Inner.Default == D>(_ inner: Inner) {
        self.key = inner.key
        
        _set = inner.set
        _get = inner.get
        _remove = inner.remove
    }
    
    public init(type: Default.Type, key: String) {
        self.key = key
        self.type = type
        _set = { _ in return }
        _get = { return nil }
        _remove = { return }
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
    public let key: String
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    public init(type: Default.Type, key: String) {
        self.key = key
    }
    
    public func set(value: Default) {
        let obj = value.serialize()
        defaults.setObject(obj, forKey: key)
    }
    
    public func get() -> Default? {
        guard let obj = defaults.objectForKey(key) else { return nil }
        return Default(obj)
    }
    
    public func remove() {
        defaults.removeObjectForKey(key)
    }
}

// MARK: -

public final class DictionaryStore<Default: DefaultConvertible>: DefaultStoreType {
    public let key: String
    
    private var dictionary: [String: AnyObject] = [:]
    
    public init(type: Default.Type, key: String) {
        self.key = key
    }
    
    public func set(value: Default) {
        let obj = value.serialize()
        dictionary[key] = obj
    }
    
    public func get() -> Default? {
        guard let obj = dictionary[key] else { return nil }
        return Default(obj)
    }
    
    public func remove() {
        dictionary[key] = nil
    }
}
