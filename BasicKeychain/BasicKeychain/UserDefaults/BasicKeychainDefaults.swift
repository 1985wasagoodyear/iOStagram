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
    
    // returns `YES` if this is the first use
    // returns `NO` if this is not the first use
    func checkSecurityFirstUseFlag(service: String) -> Bool {
        let defaults = UserDefaults.standard
        let key = "yu.BasicKeychain." + service
        let isFirstUse = !defaults.bool(forKey: key)
        if isFirstUse { defaults.set(true, forKey: key) }
        return isFirstUse
    }
}
