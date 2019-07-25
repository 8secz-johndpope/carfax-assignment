//
//  Stubs.swift
//  carfax-jamesTests
//
//  Created by James on 7/25/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation

final class Stubs {
    
    static func data(filename: String) throws -> Data {
        let url = Foundation.Bundle(for: Stubs.self)
            .url(forResource: filename, withExtension: nil)!
        return try Data(contentsOf: url)
    }
    
    static func json(filename: String) throws -> [String: Any] {
        let data = try self.data(filename: filename)
        return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    }
}
