//
//  CurrentEnvironment.swift
//  carfax-james
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

/*
 * The purpose of CurrentEnvironment is to help manage a specific
 * target's environment.  Anything specific to the target (with regards
 * to API) will be declared here.
 */

import Foundation

// type of environment for target
private let buildTimeEnvironment: Environment = .consumer

extension AppEnvironment {
    
    static var current: AppEnvironment {
        let api = ServerAPI(baseURL: buildTimeEnvironment.apiBaseURL)
        
        let env = AppEnvironment(
            environment: buildTimeEnvironment,
            api: api
        )
        AppEnvironment.shared = env
        return env
    }
}

extension AppService {
    
    // allow use of `AppService()` instead of passing in current environment's API on every call
    convenience init() {
        self.init(api: AppEnvironment.current.api)
    }
}
