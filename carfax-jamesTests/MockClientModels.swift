//
//  MockClientModels.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

@testable import carfax_james

internal func mockListingInformationModels() -> ListingInformation {
    return ListingInformation(listings: [mockListing()])
}

internal func mockListing() -> Listing {
    return Listing(
        id: "1",
        make: "Toyota",
        model: "Corolla",
        images: nil,
        year: 2002,
        trim: "LE",
        price: 2500,
        mileage: 130000,
        dealer: mockDealer()
    )
}

internal func mockDealer() -> Dealer {
    return Dealer(
        addressFirstLine: "34 Banana Ave",
        state: "Canada",
        city: "NY",
        phone: "2342551123",
        averageRating: 4
    )
}
