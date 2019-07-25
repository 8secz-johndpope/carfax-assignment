//
//  AppEnvironmentTests.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import XCTest
@testable import carfax_james

class AppEnvironmentTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEnvironmentURL() {
        let env = AppEnvironment.shared
        XCTAssertEqual(env?.api.baseURL, URL(string: "https://carfax-for-consumers.firebaseio.com/"))
    }
}
