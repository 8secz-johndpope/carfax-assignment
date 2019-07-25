//
//  ListingObjectStoreTests.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import XCTest
@testable import carfax_james

class ListingObjectStoreTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialization() {
        
        let data = try! Stubs.data(filename: "valid_from_api.json")
        let listingInformationResponse = try! ListingsInformationResponse(data: data)
        
        let listingInformation = ListingObjectStore().map(listingInformationResponse: listingInformationResponse)
        XCTAssertEqual(listingInformation.listings.count, 25)
        XCTAssertEqual(listingInformation.listings.first?.id, "19VDE1F39EE012939JGTC0PZ3A020190403")
        XCTAssertEqual(listingInformation.listings.first?.make, "Acura")
        XCTAssertEqual(listingInformation.listings.first?.model, "ILX")
        XCTAssertNotNil(listingInformation.listings.first?.images)
        XCTAssertEqual(listingInformation.listings.first?.year, 2014)
        XCTAssertEqual(listingInformation.listings.first?.trim, "Unspecified")
        XCTAssertEqual(listingInformation.listings.first?.price, 11994)
        XCTAssertEqual(listingInformation.listings.first?.mileage, 82303)
        XCTAssertNotNil(listingInformation.listings.first?.dealer)
    }
}
