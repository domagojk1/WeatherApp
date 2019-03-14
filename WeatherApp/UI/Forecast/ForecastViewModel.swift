//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ForecastViewModel {
    private let openWeatherClient: OpenWeatherClient

    // Inputs

    let dismissAction: PublishSubject<Void>

    // Outputs

    let dailyForecast: Driver<[ForecastCellViewModel]>
    let isLoading: Driver<Bool>
    let didFail: Driver<AlertMessage>

    private enum ForecastEvent {
        case loading
        case forecastData(Forecast)
        case error
    }

    static let forecastUnavailableMessage: AlertMessage = {
        return AlertMessage(title: "Forecast not available", message: "", dismissTitle: "Dismiss")
    }()

    init(city: String, openWeatherClient: OpenWeatherClient, imageDownloader: ImageDownloadable = ImageDownloader()) {
        self.openWeatherClient = openWeatherClient
        dismissAction = PublishSubject<Void>()

        let forecastEvent = openWeatherClient.forecast(for: city)
            .map { result -> ForecastEvent in
                switch result {
                case .success(let forecast):
                    return .forecastData(forecast)
                case .error:
                    return .error
                }
            }
            .asDriver(onErrorJustReturn: .error)
            .startWith(.loading)

        dailyForecast = forecastEvent
            .map {
                switch $0 {
                case .forecastData(let forecast):
                    return forecast.list.map { ForecastCellViewModel(forecastItem: $0) }
                default:
                    return []
                }
            }

        self.isLoading = forecastEvent
            .map {
                switch $0 {
                case .loading:
                    return true
                default:
                    return false
                }
        }

        self.didFail = forecastEvent
            .map {
                switch $0 {
                case .error:
                    return true
                default:
                    return false
                }
            }
            .filter { $0 }
            .map { _ in ForecastViewModel.forecastUnavailableMessage }
    }
}
