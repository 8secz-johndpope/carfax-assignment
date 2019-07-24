//
//  ServerResponse.swift
//  james-van-bev_carfax
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// just a boiler plate class to handle errors. Will need
// more information about the API for full implementation

import Foundation

public protocol ServerResponse {
    init(data: Data) throws
}

public enum ServerError: Error, ServerResponse {
    
    case network(error: NSError)
    
    case serialization(error: Error, type: Any.Type)
    
    case api(error: ErrorResponse, message: String)
    
    public var apiError: ErrorResponse? {
        switch self {
        case let .api(error, _):
            return error
        case .network, .serialization:
            return nil
        }
    }
    
    public var code: Int {
        switch self {
        case let .network(error):
            return (error as NSError).code
        case let .serialization(error, _):
            return (error as NSError).code
        case let .api(error, _):
            return error.rawValue
        }
    }
    
    public var message: String {
        switch self {
        case let .network(e):
            return e.localizedDescription
        case let .serialization(e, type):
            return "Failed to deserialize \(type) with error: \(e.localizedDescription)"
        case let .api(_, message):
            return message
        }
    }
    
    public init(data: Data, response: HTTPURLResponse) {
        guard let json: JSONDictionary = try? deserialize(data: data) else {
            self = .network(error: response.nsError)
            return
        }
        
        // boiler plate error handling - need more data on api
        guard
            let error: JSONDictionary = try? decode(json, key: "error"),
            let code: Int = try? decode(error, key: "code"),
            let message: String = try? decode(error, key: "message")
            else {
                self = .network(error: response.nsError)
                return
        }
        if let mappedError = ErrorResponse(rawValue: code) {
            self = .api(error: mappedError, message: message)
        } else {
            self = .api(error: .tbdErrors, message: message)
        }
    }
    
    public init(data: Data) throws {
        fatalError()
    }
}

private extension HTTPURLResponse {
    var nsError: NSError {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: statusCode),
            ]
        
        return NSError(
            domain: "com.carfax.http",
            code: statusCode,
            userInfo: userInfo
        )
    }
}

extension ServerResponse where Self: JSONDeserializable {
    /// Default server response parses using the `results` key.
    public init(data: Data) throws {
        let json: JSONDictionary = try deserialize(data: data)
        self = try Self(json: json)
    }
}

public struct ServerList<T: JSONDeserializable>: ServerResponse {
    
    public let models: [T]
    
    public init(data: Data) throws {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            throw JSONDeserializationError.invalidDataToJSON
        }
        
        // inner init is optional so that if one model fails to decode the entire results won't fail
        models = json.compactMap { try? T(json: $0) }
    }
}
