//
//  NWMOperations.swift
//  SwiftOperationsDriver
//
//  Created by K Y on 10/31/19.
//  Copyright © 2019 K Y. All rights reserved.
//

/*
 A Swift 5 port of William Boles's NWMOperations NSObject subclass, written originally in Objective-C.
 
 Found here:
 [NETWORKING WITH NSOPERATION AS YOUR WINGMAN - William Boles](https://williamboles.me/networking-with-nsoperation-as-your-wingman "NETWORKING WITH NSOPERATION AS YOUR WINGMAN")
 */

import Foundation

@objcMembers
open class NWMOperation: Operation {
    
    // MARK: - Override NSOperation Properties
    
    open override var isReady: Bool {
        return _isReady
    }
    open override var isExecuting: Bool {
        return _isExecuting
    }
    open override var isFinished: Bool {
        return _isFinished
    }
    
    public var _isReady: Bool = false {
        willSet {
            willChangeValue(forKey: NSStringFromSelector(#selector(getter: isReady)))
        }
        didSet {
            didChangeValue(forKey: NSStringFromSelector(#selector(getter: isReady)))
        }
    }
    public var _isExecuting: Bool = false {
        willSet {
            willChangeValue(forKey: NSStringFromSelector(#selector(getter: isExecuting)))
        }
        didSet {
            didChangeValue(forKey: NSStringFromSelector(#selector(getter: isExecuting)))
        }
    }
    public var _isFinished: Bool = false {
        willSet {
            willChangeValue(forKey: NSStringFromSelector(#selector(getter: isFinished)))
        }
        didSet {
            didChangeValue(forKey: NSStringFromSelector(#selector(getter: isFinished)))
        }
    }
    
    public var isDebuggingEnabled: Bool = false
    
    public override var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Initializer
    
    public override init() { }
    
    // MARK: - Control
    
    open override func start() {
        if isExecuting == false {
            _isReady = false
            _isExecuting = true
            _isFinished = false
            if isDebuggingEnabled, let name = name {
                print("\"\(name)\" Operation Started.")
            }
        }
    }
    
    open func finish() {
        if isDebuggingEnabled, isExecuting == true {
            if let name = name {
                print("\"\(name)\" Operation Completed.")
            }
        }
        _isExecuting = false
        _isFinished = true
    }
    
}

