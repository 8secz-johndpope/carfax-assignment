//
//  ListingCellVMTests.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

@testable import carfax_james
import XCTest

class ListingCellVMTests: XCTestCase {
    
    func testListingCellVM() {
        let vm = ListingCellViewModel(listing: mockListing())
        XCTAssertNil(vm.url)
        XCTAssertEqual(vm.priceText, "$2,500")
        XCTAssertEqual(vm.titleText, "2002 Toyota Corolla")
        XCTAssertEqual(
            vm.descriptionText, "LE · 130,000 mi · Ny, CANADA")
        XCTAssertEqual(vm.phoneText, "2342551123")
    }
}
