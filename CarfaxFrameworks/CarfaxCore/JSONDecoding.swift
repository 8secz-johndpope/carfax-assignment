//
//  JSON.swift
//  JSON
//
//  Created by Sam Soffes on 9/22/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//
// https://github.com/soffes/JSON
//
// Copyright (c) 2016 Sam Soffes, http://soff.es
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

extension JSONSerialization {
    public static func stringFromJSON(_ json: [String: Any]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    public static func jsonFromString(_ string: String) throws -> [String: Any]? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        return json as? [String: Any]
    }
}

/// JSON dictionary type alias.
///
/// Strings must be keys.
public typealias JSONDictionary = [String: Any]

/// Attempt to deserialize Data into root level JSON object `T`
///
/// - T should be either [String: Any] or [Any]
public func deserialize<T>(data: Data) throws -> T {
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? T else {
        throw JSONDeserializationError.invalidDataToJSON
    }
    return json
}

/// Protocol for things that can be deserialized with JSON.
public protocol JSONDeserializable: ServerResponse {
    /// Initialize with a JSON representation
    ///
    /// - parameter jsonRepresentation: JSON representation
    /// - throws: JSONError
    init(json: JSONDictionary) throws
}

/// Errors for deserializing JSON representations
public enum JSONDeserializationError: Error {
    /// Error deserializing Data object
    case invalidDataToJSON
    
    /// A required attribute was missing
    case missingAttribute(key: String)
    
    /// An invalid type for an attribute was found
    case invalidAttributeType(key: String, expectedType: Any.Type, receivedValue: Any)
    
    /// An attribute was invalid
    case invalidAttribute(key: String)
    
    /// An invalid JSON structure
    case invalidStructure(message: String)
}

extension JSONDeserializationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidDataToJSON:
            return "Unable to deserialize Data into JSON object"
        case let .missingAttribute(key):
            return "JSON missing attribute: \(key)"
        case let .invalidAttributeType(key, expectedType, receivedValue):
            return "JSON invalid attribute type: \(key), expected: \(expectedType), received: \(receivedValue)"
        case let .invalidAttribute(key):
            return "JSON invalid attribute: \(key)"
        case let .invalidStructure(message):
            return "JSON invalid structure: \(message)"
        }
    }
}

/// Generically decode an value from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected value
/// - throws: JSONDeserializationError
public func decode<T>(_ dictionary: JSONDictionary, key: String) throws -> T {
    
    // decode key paths in the format of "first.second.third"
    if key.contains(".") {
        var keys = key.components(separatedBy: ".")
        let firstKey = keys.removeFirst()
        guard let second = dictionary[firstKey] as? JSONDictionary else {
            throw JSONDeserializationError.invalidAttribute(key: firstKey)
        }
        return try decode(second, key: keys.joined(separator: "."))
    }
    
    guard let value = dictionary[key] else {
        throw JSONDeserializationError.missingAttribute(key: key)
    }
    
    guard let attribute = value as? T else {
        throw JSONDeserializationError.invalidAttributeType(key: key, expectedType: T.self, receivedValue: value)
    }
    
    return attribute
}

/// Decode a date value from a given JSON dictionary. ISO8601 or Unix timestamps are supported.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected value
/// - throws: JSONDeserializationError
public func decode(_ dictionary: JSONDictionary, key: String) throws -> Date {
    guard let value = dictionary[key] else {
        throw JSONDeserializationError.missingAttribute(key: key)
    }
    
    if let timeInterval = value as? TimeInterval {
        return Date(timeIntervalSince1970: timeInterval / 1_000_000)
    }
    
    throw JSONDeserializationError.invalidAttributeType(key: key, expectedType: Double.self, receivedValue: value)
}

/// Decode a URL value from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected value
/// - throws: JSONDeserializationError
public func decode(_ dictionary: JSONDictionary, key: String) throws -> URL {
    guard let string = dictionary[key] as? String else {
        throw JSONDeserializationError.missingAttribute(key: key)
    }
    
    if let url = URL(string: string) {
        return url
    }
    
    throw JSONDeserializationError.invalidAttributeType(key: key, expectedType: URL.self, receivedValue: string)
}

/// Decode a JSONDeserializable type from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected JSONDeserializable value
/// - throws: JSONDeserializationError
public func decode<T: JSONDeserializable>(_ dictionary: JSONDictionary, key: String) throws -> T {
    let value: JSONDictionary = try decode(dictionary, key: key)
    return try decode(value)
}

/// Decode an array of JSONDeserializable types from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected JSONDeserializable value
/// - throws: JSONDeserializationError
public func decode<T: JSONDeserializable>(_ dictionary: JSONDictionary, key: String) throws -> [T] {
    let values: [JSONDictionary] = try decode(dictionary, key: key)
    return try decode(values)
}

/// Decode a JSONDeserializable type
///
/// - parameter dictionary: a JSON dictionary
/// - returns: the decoded type
/// - throws: JSONDeserializationError
public func decode<T: JSONDeserializable>(_ dictionary: JSONDictionary) throws -> T {
    return try T(json: dictionary)
}

public func decode<T: JSONDeserializable>(_ array: [JSONDictionary]) throws -> [T] {
    return array.compactMap {
        do {
            return try T(json: $0)
        } catch let e {
            print("Error decoding: \(e)")
            return nil
        }
    }
}

public func encodedStringFromDictionary(_ dictionary: [String: Any]) -> String? {
    do {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let json_string = String(data: data, encoding: .utf8)
        let escaped_json_string = json_string?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        return escaped_json_string
    } catch let error {
        print("Error encoding: \(error)\ndictionary: \(dictionary)")
        return nil
    }
}
