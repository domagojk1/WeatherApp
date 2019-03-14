//
//  CelsiusConverter.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 07/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

struct CelsiusConverter { private init() {}

    static let kelvinConstant = 273.15

    static func convert(fromKelvin kelvin: Double) -> Double {
        return kelvin - CelsiusConverter.kelvinConstant
    }
}
