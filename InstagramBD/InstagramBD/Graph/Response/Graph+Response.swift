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
    
    struct MediaContainer: Decodable {
        let data: [MediaContainerInfo]
    }
    
    struct MediaContainerInfo: Decodable {
        let id: String
        let info: String?
    }
    
}

enum MediaTypes: String {
    case image = "IMAGE"
}

public struct MediaInfo: Decodable {
    public let id: String
    public let type: String
    public let urlString: String
    public let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id, timestamp
        case type = "media_type"
        case urlString = "media_url"
    }
}

public extension MediaInfo {
    var url: URL? {
        URL(string: urlString)
    }
}

public extension Array where Element == MediaInfo {
    func getImageMedias() -> [MediaInfo] {
        return self.filter { MediaTypes(rawValue: $0.type) != nil }
    }
}
