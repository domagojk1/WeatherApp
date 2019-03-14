//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

struct DailyForecast {
    let maxTemperature: String
    let minTemperature: String
    let description: String
    let icon: String
    let date: String

    init(forecast: ForecastListItem) {
        maxTemperature = "\(CelsiusConverter.convert(fromKelvin: forecast.main.tempMax).round(to: 2))"
        minTemperature = "\(CelsiusConverter.convert(fromKelvin: forecast.main.tempMin).round(to: 2))"
        description = forecast.weather.first?.description ?? ""
        icon = forecast.weather.first?.icon ?? ""
        date = DailyForecast.formatDateTime(timestamp: forecast.timestamp)
    }

    private static func formatDateTime(timestamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}


