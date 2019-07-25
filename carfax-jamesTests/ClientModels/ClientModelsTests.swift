//
//  ClientModelsTests.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import XCTest
@testable import carfax_james

class ClientModelsTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialization() {
        
        let mockListingInformation = mockListingInformationModels()
        XCTAssertEqual(mockListingInformation.listings.count, 1)
        XCTAssertEqual(mockListingInformation.listings.first?.id, "1")
        XCTAssertEqual(mockListingInformation.listings.first?.make, "Toyota")
        XCTAssertEqual(mockListingInformation.listings.first?.model, "Corolla")
        XCTAssertNil(mockListingInformation.listings.first?.images)
        XCTAssertEqual(mockListingInformation.listings.first?.year, 2002)
        XCTAssertEqual(mockListingInformation.listings.first?.trim, "LE")
        XCTAssertEqual(mockListingInformation.listings.first?.price, 2500)
        XCTAssertEqual(mockListingInformation.listings.first?.mileage, 130000)
        XCTAssertNotNil(mockListingInformation.listings.first?.dealer)
    }
}
