//
//  ErrorResponse.swift
//  james-van-bev_carfax
//
//  Created by James on 7/24/19.
//  Copyright © 2019 bevtec. All rights reserved.
//

public enum ErrorResponse: Int, Swift.Error {
    
    case tbdErrors
    
    public func message() -> String {
        return "Oops, something went wrong"
    }
}
