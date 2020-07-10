//
//  API.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation
import BasicKeychain

public enum API {
    static let root = "https://api.instagram.com"
}

public extension API {
    static var hasToken: Bool {
        return token != nil
    }
    static var token: String? {
        try? BasicKeychain(name: "yu.iOStagram",
                           service: "accessToken").get()
    }
}

// TODO: - Move this internal once WebView is moved internally
public struct IGAccessTokenResponse: Decodable {
    public let userId: Int
    public let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken = "access_token"
    }
}
