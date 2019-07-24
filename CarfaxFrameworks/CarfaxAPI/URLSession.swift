//
//  URLSession.swift
//  james-van-bev_carfax
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension URLSession {
    
    func response<T: ServerResponse>(with request: URLRequest) -> SignalProducer<T, ServerError> {
        // Let this function only parse data into json / APIResponse
        
        return reactive.data(with: request)
            .mapError { ServerError.network(error: $0 as NSError) }
            .flatMap(.concat) { data, _response -> SignalProducer<T, ServerError> in
                
                guard let response = _response as? HTTPURLResponse else {
                    fatalError("Unexpected HTTP response \(_response)")
                }
                
                print("[API] Finished: \(request)")
                print("[API] Status: \(response.statusCode)")
                print("[API] Response:\n\(String(data: data, encoding: .utf8) ?? "nil")")
                
                guard (200 ... 299).contains(response.statusCode) else {
                    let error = ServerError(data: data, response: response)
                    return SignalProducer(error: error)
                }
                
                do {
                    let rr = try T(data: data)
                    return SignalProducer(value: rr)
                } catch let error {
                    return SignalProducer(error: .serialization(error: error, type: T.self))
                }
            }
            .on(started: {
                print("[API] Started: \(request)")
            }, failed: { error in
                print("[API] Failed: \(error)")
            })
    }
}
