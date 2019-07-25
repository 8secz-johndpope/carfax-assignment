//
//  ListingInformation.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// over arching object returned from endpoint

import Foundation

public class ListingInformation {
    
    public let listings: [Listing]

    public init(listings: [Listing]) {
        self.listings = listings
    }
}
