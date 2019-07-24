//
//  ListingCell.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result
import IGListKit

public protocol ListingCellDelegate: AnyObject {
    func didTapCallButtonWith(listing: Listing)
}

public protocol ListingCellViewModelProtocol {
    var url: URL? { get }
    var priceText: String { get }
    var titleText: String { get } // year - make - model
    var descriptionText: String { get } // trim - mileage - city, state
    var phoneText: String? { get }
    
    var listing: Listing { get }
}

public class ListingCell: BindingCollectionViewCell<ListingCellViewModelProtocol>, ListBindable {
    
    // MARK: UI Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .moneyDarkGreen
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont(name: "HiraMinProN-W6", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkText
        label.font = UIFont(name: "HiraMinProN-W3", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let callButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .deepOceanBlue
        button.setImage(.icon_phone, for: .normal)
        return button
    }()
    
    public weak var delegate: ListingCellDelegate?
    
    private var vm: ListingCellViewModelProtocol?
    
    // MARK: View Life cycle
    
    public override func initializeViews() {
        layoutMargins = .zero
        layoutMargins.bottom = 6
        backgroundColor = .white
        
        [
            imageView,
            titleLabel,
            descriptionLabel,
            callButton,
            priceLabel,
        ].forEach(contentView.addSubview)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 6
        
        callButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let layoutFrame = contentView.bounds.inset(by: layoutMargins)
        
        // add image view on top of view inset by layoutMargins
        imageView.frame = layoutFrame
        // height/width ratio is 0.75 as per specs
        imageView.frame.size.height = imageView.bounds.width * 0.75
        
        // add price label to middle below image view
        let leftInset: CGFloat = 20

        priceLabel.frame.size = priceLabel.intrinsicContentSize
        priceLabel.frame.origin.y = imageView.frame.maxY + 3
        priceLabel.frame.origin.x = layoutFrame.origin.x + leftInset
        
        // add multi-line title and description label on bottom section of contentView.
        // These will be bound on the right by the call button width
        let callButtonSize = CGSize(width: 44, height: 44)
        let callButtonRightInset: CGFloat = 10
        let callButtonLabelPadding: CGFloat = 6
        let textLabelsMaxWidth: CGFloat = layoutFrame.width
            - leftInset
            - callButtonSize.width
            - callButtonRightInset
            - callButtonLabelPadding
        
        titleLabel.frame.size = CGSize(
            width: textLabelsMaxWidth,
            height: titleLabel.attributedText?
                .boundingRect(maximumWidth: textLabelsMaxWidth)
                .size.height ?? 0
        )
        titleLabel.frame.origin = CGPoint(
            x: leftInset,
            y: priceLabel.frame.maxY + 4
        )
        
        descriptionLabel.frame.size = CGSize(
            width: textLabelsMaxWidth,
            height: descriptionLabel.attributedText?
                .boundingRect(maximumWidth: textLabelsMaxWidth)
                .size.height ?? 0
        )
        let labelVerticalPadding: CGFloat = 1
        descriptionLabel.frame.origin = CGPoint(
            x: titleLabel.frame.origin.x,
            y: titleLabel.frame.maxY + labelVerticalPadding
        )
        
        // add call button to right side of bottom section - centred to labels
        callButton.frame.size = callButtonSize
        callButton.frame.origin.x = layoutFrame.width - callButtonRightInset - callButtonSize.width - callButtonLabelPadding
        
        let totalBottomHeight = (descriptionLabel.frame.maxY + layoutMargins.top + layoutMargins.bottom) - imageView.frame.maxY
        callButton.center.y = imageView.frame.maxY + (totalBottomHeight / 2.0)
        
        if descriptionLabel.text == nil {
            descriptionLabel.frame = titleLabel.frame
        }
    }
    
    // MARK: Actions
    
    @objc private func didTapButton() {
        guard let listing = vm?.listing else { return }
        delegate?.didTapCallButtonWith(listing: listing)
    }

    // MARK: Binding
    
    public override func bindViewModel(signal: Signal<ListingCellViewModelProtocol, NoError>) {
        
        priceLabel.reactive.text <~ signal.map { $0.priceText }
        titleLabel.reactive.text <~ signal.map { $0.titleText }
        descriptionLabel.reactive.text <~ signal.map { $0.descriptionText }
        callButton.reactive.isHidden <~ signal.map { $0.phoneText }.map { $0 == nil } // hide button if no phone number
        
        signal.observeValues { [weak self] vm in
            guard let self = self else { return }
            if self.reuseIdentifier != nil {
                // do not want to download image if calculating height
                self.imageView.setImage(url: vm.url, placeholder: .placeholder_car, showLoadingIndicator: true)
            }
            self.vm = vm
            self.setNeedsLayout()
        }
    }

    public func bindViewModel(_ viewModel: Any) {
        updateViewModel(viewModel as! ListingCellViewModelProtocol)
    }

    // MARK: Height calculation
    
    /// Used to calculate the height of a cell, uses a static proxy cell so we can do this without needing to dequeue
    private static let proxyCell = ListingCell()
    public static func calculateHeight(viewModel: ListingCellViewModelProtocol, width: CGFloat) -> CGFloat {
        proxyCell.frame = .zero
        proxyCell.frame.size.width = width
        proxyCell.frame.size.height = 99999
        proxyCell.updateViewModel(viewModel)
        proxyCell.layoutSubviews()
        
        return ceil(proxyCell.layoutMargins.bottom + proxyCell.layoutMargins.top + max(proxyCell.descriptionLabel.frame.maxY, proxyCell.callButton.frame.maxY))
    }
}
