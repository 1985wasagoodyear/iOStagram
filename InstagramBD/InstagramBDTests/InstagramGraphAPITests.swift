//
//  InstagramGraphAPITests.swift
//  Created 7/15/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//


import XCTest
@testable import InstagramBD

final class InstagramGraphAPITests: XCTestCase {

    func loadJSON(named name: String) -> Data {
        guard let path = Bundle(for: InstagramGraphAPITests.self)
            .path(forResource: name, ofType: "json") else {
                fatalError("File named '\(name).json' not found in testing bundle")
        }
        let url = URL(fileURLWithPath: path)
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Was unable to load file named '\(name).json' at path: \(path)")
        }
    }
    
    func testCanParseExpiredTokenResponse() {
        let data = loadJSON(named: "ExpiredTokenResponse")
        
        let decoder = JSONDecoder()
        
        XCTAssertNoThrow(try decoder.decode(Graph.RequestFailure.self, from: data))
    }

}
