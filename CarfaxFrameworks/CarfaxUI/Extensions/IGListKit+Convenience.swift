//
//  IGListKit+Convenience.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import IGListKit

extension ListSectionController {
    
    /// Use collection context dequeue method while force unwrapping the cell type for convenience
    public func dequeueBindableCell<T: UICollectionViewCell & ListBindable>(of type: T.Type, index: Int) -> T {
        return collectionContext!.dequeueReusableCell(of: type, for: self, at: index) as! T
    }
    
    /// Use collection context dequeue method while force unwrapping the cell type for convenience
    public func dequeueCell<T: UICollectionViewCell>(of type: T.Type, index: Int) -> T {
        return collectionContext!.dequeueReusableCell(of: type, for: self, at: index) as! T
    }
}
