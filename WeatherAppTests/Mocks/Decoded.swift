//
//  Decoded.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 18/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
@testable import WeatherApp

struct Decoded { private init() {}

    static let forecast: Forecast = {
        let forecastJson = SampleJson.forecast.data(using: .utf8)!
        return try! JSONDecoder().decode(Forecast.self, from: forecastJson)
    }()

    static let weather: Weather = {
        let weatherJson = SampleJson.weather.data(using: .utf8)!
        return try! JSONDecoder().decode(Weather.self, from: weatherJson)
    }()

    static let expectedCellViewModels: [ForecastCellViewModel] = {
        return forecast.list.map { ForecastCellViewModel(forecastItem: $0) }
    }()
}
