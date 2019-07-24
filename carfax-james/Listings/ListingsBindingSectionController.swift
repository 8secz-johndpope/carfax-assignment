//
//  ListingsBindingSectionController.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//
// This will convert the section into view models
// As well as handling the methods of the collectionview (similar to the UICollectionViewDataSource and delegate methods)

import Foundation
import IGListKit

public protocol ListingsBindingSectionControllerDelegate: AnyObject {
    func didTapCallButton(listSectionController: ListingsBindingSectionController, listing: Listing)
}

public final class ListingsBindingSectionController: ListBindingSectionController<ListingsSection>, ListBindingSectionControllerDataSource, ListingCellDelegate {
    
    fileprivate weak var delegate: ListingsBindingSectionControllerDelegate?
    
    public init(delegate: ListingsBindingSectionControllerDelegate?) {
        self.delegate = delegate
        
        super.init()
        
        dataSource = self
        
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
        
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    override public func didUpdate(to object: Any) {
        guard let _ = object as? ListingsSection else {
            assertionFailure("unexpected object: \(object)")
            return
        }
        super.didUpdate(to: object)
    }
}

// MARK: ListBindingSectionControllerDataSource

extension ListingsBindingSectionController {
 
    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        // convert data to cell view models
        var viewModels: [ListDiffable] = []
        
        guard let dataSource = object as? ListingsSection else { return [] }
        
        let vms = dataSource.listings.map(ListingCellViewModel.init)
        viewModels.append(contentsOf: vms)
        
        return viewModels

    }
    
    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
       // dequeue cell
        switch viewModel {
            
        case is ListingCellViewModelProtocol:
            let cell = dequeueCell(of: ListingCell.self, index: index)
            cell.delegate = self
            return cell
            
        default: fatalError("Unexpected object type: \(String(describing: object))")
        }
    }
    
    public func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        // calculate size of each cell (could use cache, but calculation seems fine)
        let width = collectionContext!.containerSize(for: self).width
        
        switch viewModel {
            
        case let vm as ListingCellViewModelProtocol:
            return CGSize(
                width: width,
                height: ListingCell.calculateHeight(viewModel: vm, width: width)
            )
            
        default:
            fatalError("Unexpected object type: \(String(describing: object))")
        }
    }
}

// MARK: ListingCellDelegate

extension ListingsBindingSectionController {

    public func didTapCallButtonWith(listing: Listing) {
        delegate?.didTapCallButton(listSectionController: self, listing: listing)
    }
}
