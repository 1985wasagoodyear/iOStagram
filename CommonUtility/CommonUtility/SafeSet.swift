//
//  BarrierSet.swift
//  Created 7/14/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

public class SafeSet<Element: Hashable> {
    
    private let queue: DispatchQueue
    private var set = Set<Element>()
    
    public init(name: String = "SafeSet") {
        self.queue = DispatchQueue(label: name)
    }
    
    public func contains(_ element: Element) -> Bool {
        queue.sync {
            set.contains(element)
        }
    }
    
    @discardableResult
    public func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        queue.sync(flags: .barrier)  {
            set.insert(element)
        }
    }
    
    @discardableResult
    public func remove(_ element: Element) -> Element? {
        queue.sync(flags: .barrier)  {
            set.remove(element)
        }
    }
    
}
