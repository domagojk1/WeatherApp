//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let currentWeatherCoordinator = CurrentWeatherCoordinator(window: window)
        return coordinate(to: currentWeatherCoordinator)
    }
}
