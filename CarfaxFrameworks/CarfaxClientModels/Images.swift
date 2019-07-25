//
//  Images.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// Images is the image information (associated with a listing)

import Foundation

public class Images {
    
    public let smallURLs: [URL]
    public let mediumURLs: [URL]
    public let largeURLs: [URL]
    public let firstImage: FirstListingsImage?
    
    public init(
        smallURLs: [URL],
        mediumURLs: [URL],
        largeURLs: [URL],
        firstImage: FirstListingsImage?
    ) {
        
        self.smallURLs = smallURLs
        self.mediumURLs = mediumURLs
        self.largeURLs = largeURLs
        self.firstImage = firstImage
    }
}
