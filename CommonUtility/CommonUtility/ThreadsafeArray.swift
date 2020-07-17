//
//  ThreadsafeArray.swift
//  W1D4MultithreadingSample
//
//  Created by K Y on 10/31/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

public class ThreadsafeArray<T> {
    
    // MARK: - Properties
    
    private var _array: [T] = []
    
    public var count: Int {
        return queue.sync {
            _array.count
        }
    }
    
    let queue: DispatchQueue
    
    public init(name: String = "ThreadsafeArray") {
        queue = DispatchQueue(label: name)
    }
    
    public convenience init(repeating: T, count: Int, name: String = "ThreadsafeArray") {
        self.init(name: name)
        _array = [T](repeating: repeating, count: count)
    }
    
    // MARK: - Accessors
    
    public subscript(_ index: Int) -> T {
        get {
            queue.sync {
                _array[index]
            }
        }
        set {
            queue.sync {
                _array[index] = newValue
            }
        }
    }
    
    public func append(_ newItem: T) {
        queue.sync {
            _array.append(newItem)
        }
    }
    
    public func get() -> [T] {
        queue.sync {
            _array
        }
    }
    
    func removeAll() {
        queue.sync {
            _array.removeAll(keepingCapacity: true)
        }
    }
    
    public func value(at index: Int) -> T {
        queue.sync {
            _array[index]
        }
    }
    
    public var array: [T] {
        queue.sync {
            _array
        }
    }

    
}
