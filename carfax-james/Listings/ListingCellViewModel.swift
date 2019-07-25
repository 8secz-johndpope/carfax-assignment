//
//  ListingCellViewModel.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import IGListKit

public final class ListingCellViewModel: ListingCellViewModelProtocol, ListDiffable {
   
    public let url: URL?
    public let priceText: String
    public let titleText: String
    public let descriptionText: String
    public let phoneText: String?
    
    public let listing: Listing
    
    public init(listing: Listing) {
        self.listing = listing
        self.url = listing.images?.firstImage?.large ?? listing.images?.firstImage?.medium ?? listing.images?.firstImage?.small
        self.priceText = format(price: listing.price)
        self.titleText = titleTextFor(listing: listing)
        self.descriptionText = descriptionTextFor(listing: listing)
        self.phoneText = listing.dealer.phone
    }
    
    public func diffIdentifier() -> NSObjectProtocol { return self as! NSObjectProtocol }
    
    /// can return true because all variables are lets
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool { return true }

}

/// Formats -parameter price into a comma separated string (removing decimals)
private func format(price: Double) -> String {
    return "$\(price.localizedString())"
}

/// combines the year, make, and model into a space-separated string
private func titleTextFor(listing: Listing) -> String {
    return [
        "\(listing.year)",
        listing.make,
        listing.model,
    ].joined(separator: " ")
}

/// adds the trim, mileage, and dealer location to a string
private func descriptionTextFor(listing: Listing) -> String {
    var descriptors: [String] = []
    if listing.trim.lowercased() != "unspecified" {
        descriptors.append(listing.trim)
    }
    descriptors.append("\(listing.mileage.localizedString()) mi")
    descriptors.append("\(listing.dealer.city.capitalized), \(listing.dealer.state.uppercased())")
    return descriptors.joined(separator: " · ")
}
