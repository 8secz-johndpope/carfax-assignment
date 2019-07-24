//
//  Double.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation

private let localSeparatedFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSeparator = Locale.current.groupingSeparator
    formatter.groupingSize = 3
    formatter.maximumFractionDigits = 3
    formatter.minimumFractionDigits = 0
    return formatter
}()

public extension Double {

    func localizedString() -> String {
        return localSeparatedFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
