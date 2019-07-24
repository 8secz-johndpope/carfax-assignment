//
//  Dictionary.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// Merge dictionary key-values, resulting in a new dictionary.
    ///
    /// - Parameter other: Values to merge with self
    /// - Returns: New dictionary
    public func merge(_ other: Dictionary) -> Dictionary {
        var copy = self
        other.forEach {
            copy[$0.key] = $0.value
        }
        return copy
    }
}
