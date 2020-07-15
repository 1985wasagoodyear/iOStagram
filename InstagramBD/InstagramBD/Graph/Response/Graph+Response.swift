//
//  Graph+Response.swift
//  Created 7/15/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension Graph {
    enum Response { }
}

extension Graph.Response {
    struct UserName: Decodable {
        let id: String
        let username: String
    }
}

