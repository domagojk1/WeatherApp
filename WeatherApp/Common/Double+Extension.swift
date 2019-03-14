//
//  Double+Extension.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 07/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation

extension Double {

    func round(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return Darwin.round(self * multiplier) / multiplier
    }
}
