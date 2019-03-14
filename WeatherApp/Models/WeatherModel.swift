//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 13/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let dateTime: String
    let weatherDescription: String
    let temperature: String
    let minTemperature: String
    let maxTemperauture: String
    let pressure: String
    let humidity: String

    init(weatherData: Weather) {
        cityName = weatherData.name
        dateTime = WeatherModel.formatDateTime(timestamp: weatherData.timestamp)
        weatherDescription = weatherData.weather.first?.description ?? "Unavailable"
        temperature = "Current temperature: \(CelsiusConverter.convert(fromKelvin: weatherData.main.temp).round(to: 2)) °C"
        minTemperature = "Minimum temperature: \(CelsiusConverter.convert(fromKelvin: weatherData.main.tempMin).round(to: 2)) °C"
        maxTemperauture = "Maximum temperature: \(CelsiusConverter.convert(fromKelvin: weatherData.main.tempMax).round(to: 2)) °C"
        pressure = "Pressure: \(weatherData.main.pressure) hPa"
        humidity = "Humidity: \(weatherData.main.humidity) %"
    }

    private static func formatDateTime(timestamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
