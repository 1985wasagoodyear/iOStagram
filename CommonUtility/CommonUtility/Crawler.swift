//
//  Crawler.swift
//  Created 7/14/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import Foundation

extension String {
    func strings(startingWith prefix: String, endingWith suffix: String) -> [String] {
        let comps = components(separatedBy: prefix)
        let subComps = comps.compactMap { $0.components(separatedBy: suffix).first }
        return subComps
    }
}

extension String {
    subscript(_ offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}

public enum Crawler {
    public static func findLinks(type: String, from string: String) -> [URL] {
        let comps = string.strings(startingWith: "https://", endingWith: type)
        return comps.compactMap { URL(string: "https://" + $0 + type) }
    }
    
    public static func findLinks(from string: String) -> [URL] {
        let comps = string.components(separatedBy: "\"src\"")
        var linkStrings: [String] = []
        for comp in comps {
            var tempString = ""
            // find first "
            var i = 0
            while comp[i] != Character("\"") { i += 1 }
            i += 1
            // go until last "
            while comp[i] != Character("\"") {
                tempString += String(comp[i])
                i += 1
            }
            tempString = tempString.replacingOccurrences(of: #"\u0026"#, with: "&")
            linkStrings.append(tempString)
        }
        return linkStrings.compactMap { URL(string: $0) }
    }
}
