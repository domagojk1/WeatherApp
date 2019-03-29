//
//  APIResult.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 28/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

enum APIResult<T: Decodable & Equatable>: Equatable {
    case success(T)
    case error(RequestError)
}

enum RequestError: Int, Error {
    case undefined = -1
    case badRequest = 400
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case serviceUnavailable = 503
}
