//
//  InstaUser.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation
import BasicKeychain

public class InstaUser {
    
    public private(set) var name: String?
    
    public let userId: String
    let credentials: API.Credentials
    
    public var token: String? {
        try? InstaUser.accessTokenKeychain().get()
    }
    
    private lazy var request: Graph.Request = {
        Graph.Request(user: self)
    }()
    
    internal init(_ apiResponse: API.Login.AccessToken.Response,
                  credentials: API.Credentials) throws {
        try InstaUser.accessTokenKeychain().set(apiResponse.accessToken)
        let userId = String(apiResponse.userId)
        try InstaUser.userIdKeychain().set(userId)
        self.userId = userId
        self.credentials = credentials
    }
    
    public init(credentials: API.Credentials) throws {
        guard let userId = try InstaUser.userIdKeychain().get() else {
            // do something else here?
            throw NSError(domain: "InstaUser credentials not found", code: 1, userInfo: nil)
        }
        self.userId = userId
        self.credentials = credentials
    }
}

extension InstaUser {
    static func accessTokenKeychain() -> BasicKeychain {
        BasicKeychain(name: "yu.iOStagram",
                      service: "accessToken")
    }
    static func userIdKeychain() -> BasicKeychain {
        BasicKeychain(name: "yu.iOStagram",
                      service: "userId")
    }
    
    static func setBadTokens() {
        try? accessTokenKeychain().set("banana")
        try? userIdKeychain().set("banana")
    }
}


public extension InstaUser {

    func getName(_ completion: @escaping (String) -> Void) {
        if let name = name {
            completion(name)
            return
        }
        request.userName { result in
            switch result {
            case .success(let name):
                self.name = name
                completion(name)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func getMedia(_ completion: @escaping (String) -> Void) {
        if let name = name {
            completion(name)
            return
        }
        request.media { result in
            switch result {
            case .success(let name):
                self.name = name
                completion(name)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
}
