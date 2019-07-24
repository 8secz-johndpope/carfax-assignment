//
//  EnvironmentSecrets.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

import Foundation

public protocol AppStrings {
    var apiBaseURL: URL { get }
}

public enum Environment: AppStrings {
    
    case consumer
    
    public var apiBaseURL: URL {
        switch self {
        case .consumer: return URL(string: "https://carfax-for-consumers.firebaseio.com/")!
        }
    }
}

