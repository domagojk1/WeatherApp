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
        switch self {
        case .weather:
            return SampleJson.weather.data(using: .utf8)!
        case .forecast:
            return SampleJson.forecast.data(using: .utf8)!
        }
    }
}
