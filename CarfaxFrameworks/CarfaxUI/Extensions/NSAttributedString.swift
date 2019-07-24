//
//  NSAttributedString.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    
    // gets the bounding rectangle for an attributed string - used mostly to calculate height
    func boundingRect(maximumWidth: CGFloat) -> CGRect {
        return boundingRect(
            with: CGSize(width: maximumWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
    }
}
