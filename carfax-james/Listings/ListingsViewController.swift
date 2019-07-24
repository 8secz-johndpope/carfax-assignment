//
//  ListingsViewController.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import UIKit
import IGListKit

public class ListingsViewController: UIViewController, ListAdapterDataSource, ListingsBindingSectionControllerDelegate {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
    )
    
    // abstracted means to feed data into collection view
    private let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: nil)

    // holds the data for this VC and it's collection view's cells
    public let dataSource: ListingsViewControllerDataSource
    
    public init(dataSource: ListingsViewControllerDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundGrey
        view.addSubview(collectionView)
        // Giving the collectionView an initial size allows cells to get sized more correctly if there is a update
        // in viewDidLoad
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .backgroundGrey
        collectionView.alwaysBounceVertical = true
        
        adapter.viewController = self
        adapter.dataSource = self
        adapter.collectionView = collectionView
        
        dataSource.sections.signal.observeValues { [weak self] _ in
            self?.adapter.performUpdates(animated: true)
        }
        
        title = NSLocalizedString("Vehicle Listings", comment: "The posts made by users to sell their cars")
    }

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard collectionView.frame != view.bounds else { return }
        collectionView.frame = view.bounds
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: ListAdapterDataSource

extension ListingsViewController {
    
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource.sections.value
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
            
        case is ListingsSection:
            return ListingsBindingSectionController(delegate: self)
            
        default:
            fatalError("Unknown object")
        }
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: ListingsBindingSectionControllerDelegate

extension ListingsViewController {

    public func didTapCallButton(listSectionController: ListingsBindingSectionController, listing: Listing) {
        dataSource.callPhone(with: listing.dealer.phone)
    }
}
