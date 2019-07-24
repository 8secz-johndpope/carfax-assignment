//
//  AppService.swift
//  james-van-bev_carfax
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

// An AppService is a container for server api data

import Foundation

public final class AppService {
    
    public let api: ServerAPI
    
    public init(api: ServerAPI) {
        self.api = api
    }
}
