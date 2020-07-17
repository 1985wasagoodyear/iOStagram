//
//  API+Login.swift
//  Created 6/29/20
//  Using Swift 5.0
//
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

extension Dictionary where Key == String, Value == String {
    // transforms a dictionary into the form:
    // "key1=value1&key2=value2&key3=value3"
    // and then transforms into ascii-encoded data
    func urlEncoded() -> Data? {
        map { $0 + "=" + $1 }
            .joined(separator: "&")
            .data(using: .ascii, allowLossyConversion: true)
    }
}

extension API {
    public enum Login {}
}

extension API.Login {
    enum AccessToken { }
    enum Authorize { }
}
