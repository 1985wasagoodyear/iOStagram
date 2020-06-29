//
//  API+Constants.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation
import InstagramBD

extension API.Credentials {
    /// place your credentials here
    static let secret: API.Credentials = {
        InstaCredentials(key: <#T##String#>,
                         secret: <#T##String#>,
                         callbackUrl: <#T##String#>,
                         scope: <#T##String#>,
                         responseType: <#T##String#>)
    }()
}
