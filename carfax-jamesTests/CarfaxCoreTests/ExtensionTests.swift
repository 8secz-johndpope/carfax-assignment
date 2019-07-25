//
//  ExtensionTests.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

@testable import carfax_james
import XCTest

class ExtensionTests: XCTestCase {
    
    func testDictionaryExtensions() {
        let mergedDic = ["id": 1, "love": 4].merge(["id1": 2, "love1": 5])
        XCTAssertNotNil(mergedDic["id"])
        XCTAssertNotNil(mergedDic["id1"])
        XCTAssertNotNil(mergedDic["love"])
        XCTAssertNotNil(mergedDic["love1"])
    }
    
    func testLocalizingStringDouble() {
        XCTAssertEqual(3.0.localizedString(), "3")
        XCTAssertEqual(3000.0.localizedString(), "3,000")
        XCTAssertEqual(30000000.0.localizedString(), "30,000,000")
        XCTAssertEqual(0.0.localizedString(), "0")
        XCTAssertEqual((-1000).localizedString(), "-1,000")
    }
}
