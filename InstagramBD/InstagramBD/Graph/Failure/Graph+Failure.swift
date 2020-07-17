//
//  Graph+Failure.swift
//  Created 7/15/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension Graph {
    struct RequestFailure: Decodable {
        let details: RequestFailureDetails
        
        enum CodingKeys: String, CodingKey {
            case details = "error"
        }
    }
    
    struct RequestFailureDetails: Decodable {
        let message: String
        let type: String
        let code: Int
        let fbTraceId: String
        
        enum CodingKeys: String, CodingKey {
            case message, type, code
            case fbTraceId = "fbtrace_id"
        }
    }
}


