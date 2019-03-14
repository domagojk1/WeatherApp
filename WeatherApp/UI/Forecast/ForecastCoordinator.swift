//
//  ForecastCoordinator.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class ForecastCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let city: String

    init(city: String, navigationController: UINavigationController) {
        self.city = city
        self.navigationController = navigationController
    }

    override func start() -> Observable<Void> {
        let forecastViewModel = ForecastViewModel(city: city, openWeatherClient: OpenWeatherClient.instance)
        let forecastViewController = ForecastController()
        forecastViewController.viewModel = forecastViewModel

        navigationController.pushViewController(forecastViewController, animated: true)

        return forecastViewModel.dismissAction.take(1)
    }
}
