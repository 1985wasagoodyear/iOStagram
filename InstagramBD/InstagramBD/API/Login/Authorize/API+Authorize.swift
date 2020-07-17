//
//  API+Authorize.swift
//  Created 7/16/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension API.Login.Authorize {
    
    public static func url(clientId: String,
                           redirectUri: String,
                           scope: String,
                           responseType: String) -> URL? {
        let urlString = API.root + "/oauth/authorize?"
            + "client_id=" + clientId
            + "&redirect_uri=" + redirectUri
            + "&scope=" + scope
            + "&response_type=" + responseType
        return URL(string: urlString)
    }
}
