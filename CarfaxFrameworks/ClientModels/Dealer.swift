//
//  Dealer.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// Dealer object

import Foundation

public class Dealer {
    
    public let addressFirstLine: String
    public let state: String
    public let city: String
    public let phone: String?
    public let averageRating: Double

    public init(
        addressFirstLine: String,
        state: String,
        city: String,
        phone: String?,
        averageRating: Double
    ) {
        
        self.addressFirstLine = addressFirstLine
        self.state = state
        self.city = city
        self.phone = phone
        self.averageRating = averageRating
    }
}
