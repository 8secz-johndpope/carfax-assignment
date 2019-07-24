//
//  ListingsSection.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import IGListKit

/// This class is the model for the section controller - will derive view models from the data
public final class ListingsSection: ListDiffable {
   
    let listings: [Listing]
    
    public init(listings: [Listing]) {
        self.listings = listings
    }
    
    // MARK: ListDiffable
    
    public func diffIdentifier() -> NSObjectProtocol { return self as! NSObjectProtocol }
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool { return true }
}
