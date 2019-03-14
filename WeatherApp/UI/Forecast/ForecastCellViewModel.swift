//
//  ForecastCellViewModel.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 13/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ForecastCellViewModel {

    // Outputs
    
    let temperature: Driver<String>
    let description: Driver<String>
    let date: Driver<String>
    let image: Driver<UIImage>

    init(forecastItem: ForecastListItem, imageDownloader: ImageDownloadable = ImageDownloader()) {
        let forecast = DailyForecast(forecast: forecastItem)

        temperature = Driver.just("\(forecast.maxTemperature) / \(forecast.minTemperature) °C")
        description = Driver.just(forecast.description)
        date = Driver.just(forecast.date)

        self.image = imageDownloader
            .image(forName: forecast.icon)
            .asDriver(onErrorJustReturn: UIImage.weatherImagePlaceholder)
    }
}
