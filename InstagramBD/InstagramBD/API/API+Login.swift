//
//  API+Login.swift
//  Created 6/29/20
//  Using Swift 5.0
//
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import OAuthSwift

extension API {
    enum Login { }
    struct SignIn {
        let credentials: Credentials
        let oauth: OAuthSwift
        
        public init(credentials: Credentials,
                    _ completion: ((Error?) -> Void)? = nil) {
            self.credentials = credentials
            oauth = API
                .Login
                .Authorize
                .oauth(key: credentials.key,
                       secret: credentials.secret,
                       callbackUrl: credentials.callbackUrl,
                       scope: credentials.scope,
                       responseType: credentials.responseType,
                       completion: completion)
        }
    }
}

extension API.Login {
    enum Authorize {
        public static func oauth(key: String,
                                 secret: String,
                                 callbackUrl: String,
                                 scope: String,
                                 responseType: String,
                                 completion: ((Error?) -> Void)? = nil) -> OAuth2Swift {
            let oauth = OAuth2Swift(
                consumerKey:    key,
                consumerSecret: secret,
                authorizeUrl:   API.root + "/oauth/authorize",
                responseType:   responseType
            )
            let _ = oauth.authorize(
                withCallbackURL: callbackUrl,
                scope: scope,
                state: "INSTAGRAM") { result in
                    switch result {
                    case .success(let (credential, response, parameters)):
                        print(credential.oauthToken)
                        completion?(nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion?(error)
                    }
            }
            return oauth
        }
        
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
}



