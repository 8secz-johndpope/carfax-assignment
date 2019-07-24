//
//  Listing.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// An individual listing encompasses all data associated with a car/dealer/etc

import Foundation

public class Listing {
    
    public let id: String
    public let make: String
    public let model: String
    public let images: Images?
    public let year: Int
    public let trim: String
    public let price: Double
    public let mileage: Double
    public let dealer: Dealer
    
    public init(
        id: String,
        make: String,
        model: String,
        images: Images?,
        year: Int,
        trim: String,
        price: Double,
        mileage: Double,
        dealer: Dealer
    ) {
        
        self.id = id
        self.make = make
        self.model = model
        self.images = images
        self.year = year
        self.trim = trim
        self.price = price
        self.mileage = mileage
        self.dealer = dealer
    }
}
