//
//  BindingCollectionViewCell.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import ReactiveSwift
import Result
import UIKit

/// Sub classes should override initializeViews and bindViewModel functions
open class BindingCollectionViewCell<T>: UICollectionViewCell {
    
    /// Private properties so sub classes don't depend on the implementation of this
    private let signal: Signal<T, NoError>
    private let observer: Signal<T, NoError>.Observer
    
    public override init(frame: CGRect) {
        (signal, observer) = Signal.pipe()
        super.init(frame: frame)
        initializeViews()
        bindViewModel(signal: signal)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        (signal, observer) = Signal.pipe()
        super.init(coder: aDecoder)
        initializeViews()
        bindViewModel(signal: signal)
    }
    
    /// Override to perform initial view setup
    open func initializeViews() {}
    
    /// Override to create bindings with the signal property
    /// This is done during initialization so try and avoid lengthy calls
    open func bindViewModel(signal: Signal<T, NoError>) {}
    
    /// Interface for updating the cell with a new view model
    public final func updateViewModel(_ vm: T) {
        observer.send(value: vm)
    }
}
