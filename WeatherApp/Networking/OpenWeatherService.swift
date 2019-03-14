//
//  OpenWeather.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import Moya

enum OpenWeatherService {
    case weather(_ city: String)
    case forecast(_ city: String)
}

extension OpenWeatherService: TargetType {
    typealias Method = Moya.Method

    static let apiKey = "95453dcae137c3505bb45e88ecc00272"

    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/")!
    }

    var method: Method {
        return .get
    }

    var path: String {
        switch self {
        case .weather(_):
            return "weather"
        case .forecast(_):
            return "forecast"
        }
    }

    var task: Task {
        var city: String
        switch self {
        case .forecast(let cityName):
            city = cityName
        case .weather(let cityName):
            city = cityName
        }

        return .requestParameters(parameters: ["q": city,
                                               "APPID": OpenWeatherService.apiKey],
                                              encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    var sampleData: Data {
        return "{\"coord\":{\"lon\":-0.13,\"lat\":51.51},\"weather\":[{\"id\":300,\"main\":\"Drizzle\",\"description\":\"light intensity drizzle\",\"icon\":\"09d\"}],\"base\":\"stations\",\"main\":{\"temp\":280.32,\"pressure\":1012,\"humidity\":81,\"temp_min\":279.15,\"temp_max\":281.15},\"visibility\":10000,\"wind\":{\"speed\":4.1,\"deg\":80},\"clouds\":{\"all\":90},\"dt\":1485789600,\"sys\":{\"type\":1,\"id\":5091,\"message\":0.0103,\"country\":\"GB\",\"sunrise\":1485762037,\"sunset\":1485794875},\"id\":2643743,\"name\":\"London\",\"cod\":200}".data(using: .utf8)!
    }
}
