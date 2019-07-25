//
//  FirstListingsImage.swift
//  carfax-james
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation

public class FirstListingsImage {
    
    public let small: URL
    public let medium: URL
    public let large: URL
    
    public init(
        small: URL,
        medium: URL,
        large: URL
    ) {
        
        self.small = small
        self.medium = small
        self.large = large
    }
}
