//
//  Forecast.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    let list: [ForecastListItem]
}

struct ForecastListItem: Decodable {
    let timestamp: Int
    let main: MainData
    let wind: WindData
    let weather: [WeatherData]

    private enum CodingKeys : String, CodingKey {
        case timestamp = "dt"
        case main, wind, weather
    }
}
