///
/// This file is created at build time from scripts/image_assets.swift
/// Do not modify directly.
///

import UIKit

private class Container {}

public extension UIImage {

    private convenience init(iconNamed: String) {
        self.init(named: iconNamed, in: Bundle(for: Container.self), compatibleWith: nil)!
    }

    static var icon_phone: UIImage {
        return UIImage(iconNamed: "icon-phone")
    }

    static var placeholder_car: UIImage {
        return UIImage(iconNamed: "placeholder-car")
    }
}
