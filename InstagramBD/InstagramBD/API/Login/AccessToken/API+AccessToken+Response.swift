//
//  API+AccessTokenResponse.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension API.Login.AccessToken {
    struct Response: Decodable {
        public let userId: Int
        public let accessToken: String
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case accessToken = "access_token"
        }
    }
}
