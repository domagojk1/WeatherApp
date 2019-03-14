//
//  NetworkingMocks.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 11/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import Moya
@testable import WeatherApp

struct NetworkingMocks {
    private init() {}

    static var openWeatherImmediateClient: OpenWeatherClient = {
        let stubMoyaProvider = MoyaProvider<OpenWeatherService>(stubClosure: MoyaProvider.immediatelyStub)
        let apiClient = APIClient(provider: stubMoyaProvider)
        return OpenWeatherClient(apiClient: apiClient)
    }()

    static func openWeatherImmediateErrorClient(responseCode: Int = NetworkingMocks.serverErrorResponseCode,
                                                responseData: Data = NetworkingMocks.emptyDataResponse) -> OpenWeatherClient {
        let endpointClosure = { (target: OpenWeatherService) -> Endpoint in
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(responseCode, responseData )},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }

        let stubMoyaProvider = MoyaProvider(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let apiClient = APIClient(provider: stubMoyaProvider)
        return OpenWeatherClient(apiClient: apiClient)
    }
}

extension NetworkingMocks {

    static let serverErrorResponseCode = 500
    static let emptyDataResponse = Data()
}
