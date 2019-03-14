//
//  CurrentWeatherCoordinator.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class CurrentWeatherCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let weatherViewModel = WeatherViewModel(initialCity: "Zagreb",
                                                openWeatherClient: OpenWeatherClient.instance,
                                                scheduler: MainScheduler.instance,
                                                imageDownloader: ImageDownloader())
        
        let weatherController = WeatherController()
        weatherController.viewModel = weatherViewModel

        let navigationController = UINavigationController(rootViewController: weatherController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        weatherViewModel.showForecast
            .flatMap { [weak self] city -> Observable<Void> in
                guard let self = self else {
                    return Observable.empty()
                }

                return self.showForecast(for: city, on: navigationController)
            }
            .subscribe()
            .disposed(by: bag)

        return Observable.never()
    }

    private func showForecast(for city: String, on navigationController: UINavigationController) -> Observable<Void> {
        let forecastCoordinator = ForecastCoordinator(city: city, navigationController: navigationController)
        return coordinate(to: forecastCoordinator)
    }
}
