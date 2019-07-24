//
//  Endpoints.swift
//  james-van-bev_carfax
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import ReactiveSwift

/// API Endpoint
struct Endpoint {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case update = "UPDATE"
    }
    
    let path: String
    
    /// HTTP method of the request
    let method: Method
    
    /// Parameters in GET requests become the url query params.
    /// Parameters in POST, PUT, or UPDATE get encoded as the request body
    let parameters: [String: Any]
    
    /// Marked as internal because new endpoints shouldn't be created outside.
    /// If we need additional endpoints for the api server they should all be in one place.
    init(path: String, method: Method = .get, parameters: [String: Any] = [:]) {
        self.path = path
        self.method = method
        self.parameters = parameters
    }
    
    /// Build a URLRequest on top of a base URL.
    func request(baseURL: URL) -> URLRequest {
        
        guard let url = URL(string: path, relativeTo: baseURL) else {
            fatalError("URL(string: \(path), relativeTo: \(baseURL.absoluteString)) is nil")
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        switch method {
        case .post, .put:
            if request.httpBody == nil {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        default:
            if parameters.count > 0, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                components.queryItems = parameters.map {
                    URLQueryItem(name: $0, value: String(describing: $1))
                }
                request.url = components.url
            }
        }
        return request
    }
}

// MARK: Listings

public extension ServerAPI {
    
    func getListingsData() -> ServerRequest<ListingsInformationResponse> {
        return request(Endpoint(path: "assignment.json"))
    }
}
