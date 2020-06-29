//
//  API+Credentials.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension API {
    public struct Credentials {
        let key: String
        let secret: String
        let callbackUrl: String
        let scope: String
        let responseType: String
        
        public init(key: String,
                    secret: String,
                    callbackUrl: String,
                    scope: String = "user_profile,user_media",
                    responseType: String = "code") {
            self.key = key
            self.secret = secret
            self.callbackUrl = callbackUrl
            self.scope = scope
            self.responseType = responseType
        }
        
        public func makeUrl() -> URL? {
            return API
                .Login
                .Authorize
                .url(clientId: key,
                     redirectUri: callbackUrl,
                     scope: scope,
                     responseType: responseType)
        }
    }
}
