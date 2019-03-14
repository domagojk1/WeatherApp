//
//  WeatherController.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherController: BaseController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var showForecastButton: UIBarButtonItem!
    var viewModel: WeatherViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Current weather"
        showForecastButton = UIBarButtonItem(title: "Forecast", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = showForecastButton

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white

        setupBinding()
    }

    private func setupBinding() {
        showForecastButton.rx.tap.bind(to: viewModel.chooseForecast)
            .disposed(by: bag)

        citySearchBar.rx.text.orEmpty.bind(to: viewModel.city)
            .disposed(by: bag)

        viewModel.isLoading.map { !$0 }.drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)

        viewModel.isLoading.map { !$0 }.drive(activityIndicator.rx.isHidden)
            .disposed(by: bag)

        viewModel.weatherImage.drive(weatherImageView.rx.image)
            .disposed(by: bag)

        viewModel.weatherModel.drive(onNext: { [weak self] weather in
            self?.setTexts(from: weather)
        }).disposed(by: bag)

        viewModel.didFail.drive(alertMessage)
            .disposed(by: bag)
    }

    private func setTexts(from weather: WeatherModel) {
        self.cityNameLabel.text = weather.cityName
        self.dateTimeLabel.text = weather.dateTime
        self.weatherDescriptionLabel.text = weather.weatherDescription
        self.temperatureLabel.text = weather.temperature
        self.minTemperatureLabel.text = weather.minTemperature
        self.maxTemperatureLabel.text = weather.maxTemperauture
        self.pressureLabel.text = weather.pressure
        self.humidityLabel.text = weather.humidity
    }
}
