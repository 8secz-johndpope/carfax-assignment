//
//  CarfaxAnimatableImageView.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import ReactiveSwift
import Result
import UIKit
import YYWebImage

/// IMO a better alternative to alamofire image handling.
/// has cache and a lot of support

extension UIImageView {
    
    private struct AssociatedKeys {
        static var IndicatorView = "carfax.indicator-view"
    }
    
    internal var activityIndicatorView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.IndicatorView) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.IndicatorView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func startActivityIndicator() {
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(style: .white)
            addSubview(activityIndicatorView!)
        }
        
        activityIndicatorView?.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        activityIndicatorView?.color = self.tintColor.withAlphaComponent(0.5)
        activityIndicatorView?.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicatorView?.stopAnimating()
    }
    
    @objc public func cancelImageRequest() {
        setImage(url: nil)
    }
    
    @objc public func setImage(url: URL?, placeholder: UIImage? = nil, showLoadingIndicator: Bool = false, completion: ((UIImage?) -> Void)? = nil) {
        yy_cancelCurrentImageRequest()
        
        image = placeholder
        
        guard let url = url else {
            stopActivityIndicator()
            return
        }
        
        if showLoadingIndicator {
            startActivityIndicator()
        }
        
        func log(error: Error?) {
            guard let error = error else { return }
            #if DEBUG
            print("Error downloading image: (\(url.absoluteString)) - (\(error.localizedDescription))")
            #endif
        }
        
        yy_setImage(with: url, placeholder: placeholder, options: []) { image, url, from, stage, error in
            if stage != .cancelled {
                self.stopActivityIndicator()
            }
            log(error: error)
            completion?(image)
        }
    }
    
    public static func downloadImage(_ url: URL, completion: ((UIImage?) -> Void)?) {
        DispatchQueue.main.async {
            var ref: UIImageView! = UIImageView()
            ref.yy_setImage(with: url, placeholder: nil, options: [.avoidSetImage]) { image, url, webImageFromType, webImageState, error in
                DispatchQueue.main.async {
                    completion?(image)
                    ref = nil
                }
            }
        }
    }
    
    public static func storeURLCache(data: Data, url: URL) {
        YYImageCache.shared().setImage(nil, imageData: data, forKey: url.absoluteString, with: .all)
    }
}

// MARK: - Cache Management

extension UIImageView {
    public static func clearImageCache() {
        URLCache.shared.removeAllCachedResponses()
        let cache = YYWebImageManager.shared().cache
        cache?.diskCache.removeAllObjects()
        cache?.memoryCache.removeAllObjects()
    }
}
