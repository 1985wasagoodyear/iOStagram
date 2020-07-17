//
//  Graph+GraphError.swift
//  Created 7/16/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

public extension Graph {
    enum GraphError: Error {
        case noToken
        case noData
        case badUrl(String)
        case expiredToken
        case unknown(String)
        
        init(response: RequestFailure) {
            switch response.details.code {
            case 190:
                self = .expiredToken
            default:
                self = .unknown(response.details.message)
            }
        }
    }
}
