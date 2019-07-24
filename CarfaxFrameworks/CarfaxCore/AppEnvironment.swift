//
//  AppEnvironment.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// Allows generic use of api across multiple targets and apps

import Foundation

public class AppEnvironment {
    
    public static var shared: AppEnvironment!
    
    public let environment: Environment
    public let api: ServerAPI
        
    public init(
        environment: Environment,
        api: ServerAPI
    ) {
        
        self.environment = environment
        self.api = api
    }
}

extension AppEnvironment: AppStrings {
    public var apiBaseURL: URL { return environment.apiBaseURL }
}
