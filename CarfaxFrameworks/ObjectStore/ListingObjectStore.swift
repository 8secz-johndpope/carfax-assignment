//
//  ListingObjectStore.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

/*
*  ListingObjectStore will handle conversion of API-responses into app-readable objects.
* This allows a separation of server returned values and app specific.
*/

import Foundation

public final class ListingObjectStore {
    
    func map(listingInformationResponse: ListingsInformationResponse) -> ListingInformation {
        return ListingInformation(listings: listingInformationResponse.listings.map(map))
    }
    
    public func map(listingResponse: ListingResponse) -> Listing {
       
        return Listing(
            id: listingResponse.id,
            make: listingResponse.make,
            model: listingResponse.model,
            images: map(imagesResponse: listingResponse.imagesResponse),
            year: listingResponse.year,
            trim: listingResponse.trim,
            price: listingResponse.price,
            mileage: listingResponse.mileage,
            dealer: map(dealerResponse: listingResponse.dealerResponse)
        )
    }
    
    public func map(imagesResponse: ImagesResponse?) -> Images? {
        
        guard let imagesResponse = imagesResponse else { return nil }
        return Images(
            smallURLs: imagesResponse.smallURLs.map { URL(string: $0)! },
            mediumURLs: imagesResponse.mediumURLs.map { URL(string: $0)! },
            largeURLs: imagesResponse.largeURLs.map { URL(string: $0)! },
            firstImage: map(firstListingsImageResponse: imagesResponse.firstImage)
        )
    }
    
    public func map(dealerResponse: DealerResponse) -> Dealer {
        
        return Dealer(
            addressFirstLine: dealerResponse.addressFirstLine,
            state: dealerResponse.state,
            city: dealerResponse.city,
            phone: dealerResponse.phone,
            averageRating: dealerResponse.averageRating
        )
    }
    
    public func map(firstListingsImageResponse: FirstListingsImageResponse?) -> FirstListingsImage? {
       
        guard let firstListingsImageResponse = firstListingsImageResponse else { return nil }
        return FirstListingsImage(
            small: URL(string: firstListingsImageResponse.small)!,
            medium: URL(string: firstListingsImageResponse.medium)!,
            large: URL(string: firstListingsImageResponse.large)!
        )
    }
}
