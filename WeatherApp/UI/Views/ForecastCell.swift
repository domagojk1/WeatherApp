//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import UIKit
import RxSwift

class ForecastCell: UITableViewCell {
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!
    @IBOutlet weak var forecastTemperatureLabel: UILabel!
    @IBOutlet weak var forecastDateLabel: UILabel!

    private(set) var disposeBag = DisposeBag()
    static let cellReuseId = "ForecastCell"

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func drive(viewModel: ForecastCellViewModel) {
        viewModel.image.drive(forecastImage.rx.image)
            .disposed(by: disposeBag)

        viewModel.description.drive(forecastDescriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.temperature.drive(forecastTemperatureLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.date.drive(forecastDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
