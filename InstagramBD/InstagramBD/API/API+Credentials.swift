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
        let session: URLSession
        
        public init(key: String,
                    secret: String,
                    callbackUrl: String,
                    scope: String = "user_profile,user_media",
                    responseType: String = "code",
                    session: URLSession = URLSession(configuration: .ephemeral)) {
            self.key = key
            self.secret = secret
            self.callbackUrl = callbackUrl
            self.scope = scope
            self.responseType = responseType
            self.session = session
        }
    }
}

extension API.Credentials {
    
    func makeUrl() -> URL? {
        API.Login
            .Authorize
            .url(clientId: key,
                 redirectUri: callbackUrl,
                 scope: scope,
                 responseType: responseType)
    }
    
    func makeRedirect(from url: URL) -> URLRequest? {
        guard let code = API.Credentials.parse(prefix: "code", from: url) else {
            return nil
        }
        return API.Login.AccessToken.urlRequest(
            clientId: key,
            clientSecret: secret,
            grantType: "authorization_code",
            redirectUri: callbackUrl,
            code: code)
    }
    
    static func parse(prefix: String, from url: URL) -> String? {
        guard let query = url.query,
            query.hasPrefix("\(prefix)=") else {
                return nil
        }
        let code = String(query.dropFirst(prefix.count + 1))
        guard code.isEmpty == false else { return nil }
        return code
    }
    
}

