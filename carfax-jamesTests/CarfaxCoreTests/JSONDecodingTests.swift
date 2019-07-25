//
//  JSONDecodingTests.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

@testable import carfax_james
import XCTest

class JSONDecodingTests: XCTestCase {
    
    func testDateDecodesNanoSeconds() throws {
        let json: [String: Any] = ["ts": 1_515_166_372_426_258.0]
        let date: Date = try decode(json, key: "ts")
        XCTAssertEqual(date, Date(timeIntervalSince1970: 1_515_166_372_426_258 / 1_000_000))
    }
}
