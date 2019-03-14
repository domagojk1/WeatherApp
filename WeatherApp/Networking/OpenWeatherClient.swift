//
//  OpenWeatherClient.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class OpenWeatherClient {
    private let apiClient: APIClient<OpenWeatherService>

    init(apiClient: APIClient<OpenWeatherService>) {
        self.apiClient = apiClient
    }

    func weather(for city: String) -> Single<APIResult<Weather>> {
        return apiClient.request(target: .weather(city))
    }

    func forecast(for city: String) -> Single<APIResult<Forecast>> {
        return apiClient.request(target: .forecast(city))
    }
}

extension OpenWeatherClient {

    static let instance: OpenWeatherClient = {
        let provider = MoyaProvider<OpenWeatherService>()
        let apiClient = APIClient(provider: provider)
        return OpenWeatherClient(apiClient: apiClient)
    }()
}
