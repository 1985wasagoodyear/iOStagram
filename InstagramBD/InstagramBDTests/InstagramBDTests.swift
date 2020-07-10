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
    
    func testCanRetrieveCode() {
        let code = "AQAV0hna0G5B0SZhBWXc2keH9dHtwpixAXm6EcNqqZ6Al2AqbWxhD0tGL69Or7HE0LYj6dbx3jNkJYwI6HbZQ0pwepvcf_xOsIGpJQTOldL2Drge8jea9cNrS-nKEJqoidgmSge6EgLl3_37CW4_T4P4Skm3XP_PUTq18qtoM4OL7uJUcW2h_ILbPJnoM1jVyBwt4RPsypde2rbWnV2U_65BYbsaHSL7tWrDFPgg-wuACw"
        let url = URL(string: "https://github.com/1985wasagoodyear?code=\(code)#_")!
        
        let parsedCode = API.Credentials.parse(prefix: "code", from: url)
        
        XCTAssertNotNil(parsedCode)
        XCTAssertEqual(code, parsedCode)
    }

}
