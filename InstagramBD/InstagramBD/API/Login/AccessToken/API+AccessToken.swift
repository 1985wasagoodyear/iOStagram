//
//  API+AccessToken.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension API.Login.AccessToken {
    public static func urlRequest(clientId: String,
                                  clientSecret: String,
                                  grantType: String,
                                  redirectUri: String,
                                  code: String) -> URLRequest? {
        guard let url = URL(string: API.root + "/oauth/access_token") else {
            return nil
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 1.0)
        let body = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type": grantType,
            "redirect_uri": redirectUri,
            "code": code
            ].encoded()
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField:"Content-Type")
        request.setValue(String(body?.count ?? 0),
                         forHTTPHeaderField: "Content-Length")
        request.setValue("application/json",
                         forHTTPHeaderField:"Accept")
        request.httpBody = body
        return request
    }

}
