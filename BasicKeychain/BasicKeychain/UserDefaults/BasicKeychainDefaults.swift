//
//  BasicKeychainDefaults.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

struct BasicKeychainDefaults {
    let defaults = UserDefaults.standard
    func set(service: String) {
        defaults.set(true, forKey: service)
    }
    func get(service: String) -> Bool {
        defaults.bool(forKey: service)
    }
    // returns `YES` if this is the first use
    // returns `NO` if this is not the first use
    func checkSecurityFirstUseFlag(service: String) -> Bool {
        let isFirstUse = !defaults.bool(forKey: "yu.BasicKeychain." + service)
        if isFirstUse {
            defaults.set(true, forKey: "yu.BasicKeychain." + service)
            print("did set first-use flag")
        }
        return isFirstUse
    }
}
