//
//  ListingDataSource.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

/*
 * This class manages the data for everything listing-related
 */

import Foundation
import ReactiveSwift
import Result

public final class ListingDataSource {
    
    // api data specific to current environment
    public let service: AppService
    // handle conversion from api-response to app readable data
    public let store: ListingObjectStore
    
    public init(service: AppService) {
        self.service = service
        self.store = ListingObjectStore()
    }
    
   /*
   * fetchListingsInformation: will retrieve all the listing data from given endpoint
   * returns signal producer with information
   */
    public func fetchListingsInformation() -> SignalProducer<ListingInformation, ServerError> {
        return service.api.getListingsData().producer
            .map { self.store.map(listingInformationResponse: $0) }
            .observe(on: UIScheduler())
    }
}

