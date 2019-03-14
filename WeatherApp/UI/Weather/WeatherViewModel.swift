//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherViewModel {
    private let openWeatherClient: OpenWeatherClient
    private let imageDownloader: ImageDownloadable

    // Inputs

    let city: PublishSubject<String>
    let chooseForecast: PublishSubject<Void>

    // Outputs

    let weatherModel: Driver<WeatherModel>
    let isLoading: Driver<Bool>
    let didFail: Driver<AlertMessage>
    let weatherImage: Driver<UIImage>
    let showForecast: Observable<String>

    private enum WeatherEvent {
        case loading
        case weatherData(Weather)
        case error
    }

    static let weatherUnavailableMessage: AlertMessage = {
        return AlertMessage(title: "Weather not available for current search", message: "", dismissTitle: "Dismiss")
    }()

    init(initialCity: String, openWeatherClient: OpenWeatherClient, scheduler: SchedulerType, imageDownloader: ImageDownloadable) {
        self.openWeatherClient = openWeatherClient
        self.imageDownloader = imageDownloader

        city = PublishSubject<String>()
        chooseForecast = PublishSubject<Void>()

        let weatherEvent: Driver<WeatherEvent> = city
            .debounce(0.5, scheduler: scheduler)
            .distinctUntilChanged()
            .startWith(initialCity)
            .filter { $0.count > 0 }
            .flatMapLatest {
                return openWeatherClient.weather(for: $0)
                    .asObservable()
                    .map { result in
                        switch result {
                        case .success(let weather):
                            return .weatherData(weather)
                        case .error:
                            return .error
                        }
                    }
                    .startWith(.loading)
            }
            .asDriver(onErrorJustReturn: .error)

        self.isLoading = weatherEvent
            .map {
                switch $0 {
                case .loading:
                    return true
                default:
                    return false
                }
            }

        self.didFail = weatherEvent
            .map {
                switch $0 {
                case .error:
                    return true
                default:
                    return false
                }
            }
            .filter { $0 }
            .map { _ in WeatherViewModel.weatherUnavailableMessage }

        let weatherDataEvent = weatherEvent
            .map { event -> Weather? in
                switch event {
                case .weatherData(let weather):
                    return weather
                default:
                    return nil
                }
            }
            .filter { $0 != nil }

        let weatherCity = weatherDataEvent.map { $0!.name }

        showForecast = chooseForecast.withLatestFrom(weatherCity.asObservable())

        self.weatherModel = weatherDataEvent.map { WeatherModel(weatherData: $0!) }

        self.weatherImage = weatherDataEvent.map { $0!.weather.first?.icon }
            .asObservable()
            .filter { $0 != nil }
            .flatMap { imageDownloader.image(forName: $0!) }
            .asDriver(onErrorJustReturn: UIImage.weatherImagePlaceholder)
    }
}
