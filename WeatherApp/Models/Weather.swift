//
//  Weather.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let weather: [WeatherData]
    let main: MainData
    let wind: WindData
    let timestamp: Int

    private enum CodingKeys : String, CodingKey {
        case timestamp = "dt"
        case name, weather, main, wind
    }
}

struct WeatherData: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct MainData: Decodable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let tempMin: Double
    let tempMax: Double

    private enum CodingKeys : String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp, pressure, humidity
    }
}

struct WindData: Decodable {
    let speed: Double
    let deg: Double?
}
