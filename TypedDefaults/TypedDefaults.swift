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
    
    /// Desirialize Any to adopted object.
    /// The argument "object" is intended to be passed from DefaultStoreType
    init?(_ object: Any)
    
    /// Serialize adopted object to Any for setting it to DefaultStoreType.
    func serialize() -> Any
}

// MARK: - DefaultStoreType

public protocol DefaultStoreType {
    
    associatedtype Default: DefaultConvertible
  
    func set(_ value: Default)
    func get() -> Default?
    func remove()
}

// MARK: -

public final class AnyStore<D: DefaultConvertible>: DefaultStoreType {
    
    public typealias Default = D
    
    private let _set: (Default) -> ()
    private let _get: () -> Default?
    private let _remove: () -> ()
    
    public init<Inner: DefaultStoreType>(_ inner: Inner) where Inner.Default == D {
        _set = inner.set
        _get = inner.get
        _remove = inner.remove
    }
    
    public func set(_ value: Default) {
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

public final class PersistentStore<Default: DefaultConvertible>: DefaultStoreType {
    
    private let defaults = UserDefaults.standard
    
    public init() {}
    
    public func set(_ value: Default) {
        let obj = value.serialize()
        defaults.set(obj, forKey: Default.key)
    }
    
    public func get() -> Default? {
        guard let obj = defaults.object(forKey: Default.key) else { return nil }
        return Default(obj)
    }
    
    public func remove() {
        defaults.removeObject(forKey: Default.key)
    }
    
    public func syncronize() -> Bool {
        return defaults.synchronize()
    }
}

// MARK: -

public final class InMemoryStore<Default: DefaultConvertible>: DefaultStoreType {
    
    private var dictionary: [String: Any] = [:]
    
    public init() {}
    
    public func set(_ value: Default) {
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
