//
//  ListingsViewControllerDataSource.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import IGListKit

public final class ListingsViewControllerDataSource {
    
    // model for collection view
    public let sections: Property<[ListDiffable]>
    private let _sections = MutableProperty<[ListDiffable]>([])
    
    // active when refreshing
    public let isRefreshing: Property<Bool>
    private let _isRefreshing: MutableProperty<Bool> = MutableProperty(false)

    public init() {
        self.isRefreshing = Property(_isRefreshing)
        self.sections = Property(_sections)
    }
    
    /// Fetch listing results from server and update sections - causing refresh of collection view
    public func refresh() {
        ListingDataSource(service: AppService())
            .fetchListingsInformation()
            .on(starting: { [weak self] in
                self?._isRefreshing.value = true
            }, terminated: { [weak self] in
                self?._isRefreshing.value = false
            })
            .startWithResult { [weak self] result in
                switch result {
                case .failure: break
                case let .success(listingInformation):
                    self?._sections.value = [ListingsSection(listings: listingInformation.listings)]
                }
            }
    }
    
    /// callPhone(with phoneNumber: String?)
    /// Attempts to make a call if user has capable device
    /// - parameter phoneNumber - String phone number - all numbers (in string)
    public func callPhone(with phoneNumber: String?) {
        guard let phoneNumber = phoneNumber, !phoneNumber.isEmpty else { return }
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(phoneCallURL)
        {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
}
