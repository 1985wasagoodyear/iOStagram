//
//  CommonUtilityTests.swift
//  Created 7/14/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import XCTest
@testable import CommonUtility

class SafeSetTests: XCTestCase {
    
    let set = SafeSet<Int>()

    func test_concurrent_insert() {
        DispatchQueue.concurrentPerform(iterations: 100_000) {_ in
            let random = Int.random(in: 1...10)
            set.insert(random)
        }
    }
    
    func test_concurrent_random() {
        DispatchQueue.concurrentPerform(iterations: 100_000) { _ in
            let op = Int.random(in: 0...2)
            let random = Int.random(in: 1...10)
            switch op {
            case 0:
                set.insert(random)
            case 1:
                set.remove(random)
            default:
                let _ = set.contains(random)
            }
        }
    }

}


class ThreadsafeArrayTests: XCTestCase {
    
    let array = ThreadsafeArray<Int>()
    
    func test_concurrent_insert() {
        DispatchQueue.concurrentPerform(iterations: 100_000) {_ in
            let random = Int.random(in: 1...10)
            array.append(random)
        }
    }
    
    func test_concurrent_random() {
        DispatchQueue.concurrentPerform(iterations: 100_000) { _ in
            switch Bool.random() {
            case true:
                let random = Int.random(in: 1...10)
                array.append(random)
            case false:
                array.removeAll()
            }
        }
    }
}
