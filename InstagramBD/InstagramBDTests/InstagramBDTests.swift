//
//  InstagramBDTests.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import XCTest
@testable import InstagramBD

class InstagramBDTests: XCTestCase {

    func testCanBuildAuthorizeUrl() {
        let targetUrl = "https://api.instagram.com/oauth/authorize?client_id=684477648739411&redirect_uri=https://socialsizzle.herokuapp.com/auth/&scope=user_profile,user_media&response_type=code"
        let url = API.Login.Authorize.url(clientId: "684477648739411",
                                          redirectUri: "https://socialsizzle.herokuapp.com/auth/",
                                          scope: "user_profile,user_media",
                                          responseType: "code")?.absoluteString
        XCTAssertNotNil(url)
        XCTAssertEqual(targetUrl, url)
    }

}
