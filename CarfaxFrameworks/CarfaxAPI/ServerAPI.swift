//
//  ServerAPI.swift
//  james-van-bev_carfax
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import UIKit

/// Wrap URLRequest with ReactiveSwift SignalProducer
public struct ServerRequest<T: ServerResponse> {
    public let request: URLRequest
    public let session: URLSession
    
    let endpoint: Endpoint
    let api: ServerAPI
    
    public var producer: SignalProducer<T, ServerError> {
        return session
            .response(with: self.request)
            .flatMapError { self.api.handle(error: $0, request: self) }
    }
}

public final class ServerAPI {
    
    let session: URLSession
    
    /// Default server API URL. Used for most every endpoint
    let baseURL: URL
    
    public init(
        session: URLSession = URLSession.shared,
        baseURL: URL
    ) {
        
        self.baseURL = baseURL
        self.session = session
    }
    
    /// Generic request that we can use to map the response to a specific data model
    internal func request<T: ServerResponse>(_ endpoint: Endpoint, baseURL: URL? = nil) -> ServerRequest<T> {
        let baseURL = baseURL ?? self.baseURL
        var request: URLRequest = endpoint.request(baseURL: baseURL)
        
        setDefaultHeaders(request: &request)
        
        return ServerRequest(request: request, session: session, endpoint: endpoint, api: self)
    }
    
    internal func handle<T>(error: ServerError, request: ServerRequest<T>) -> SignalProducer<T, ServerError> {
        switch error {
        case .api:
            return SignalProducer(error: error)
        default:
            return SignalProducer(error: error)
        }
    }
    
    /// Apply standard HTTP request headers
    fileprivate func setDefaultHeaders(request: inout URLRequest) {
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("iOS", forHTTPHeaderField: "X-Carfax-Platform")
        request.setValue(UIDevice.current.systemVersion, forHTTPHeaderField: "Accept-Version")
        request.setValue(UIDevice.current.name, forHTTPHeaderField: "X-Dev-Name")
    }
}
