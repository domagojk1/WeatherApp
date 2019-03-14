//
//  ForecastController.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastController: BaseController {
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: ForecastViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white

        forecastTableView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: ForecastCell.cellReuseId)
        forecastTableView.separatorStyle = .none
        forecastTableView.rowHeight = 100
        forecastTableView.allowsSelection = false
        
        setupBinding()
    }

    private func setupBinding() {
        poppedFromNavigationStack.bind(to: viewModel.dismissAction)
            .disposed(by: bag)

        viewModel.didFail.drive(alertMessage)
            .disposed(by: bag)

        viewModel.isLoading.map { !$0 }.drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)

        viewModel.isLoading.map { !$0 }.drive(activityIndicator.rx.isHidden)
            .disposed(by: bag)

        viewModel
            .dailyForecast
            .drive(forecastTableView.rx.items(cellIdentifier: ForecastCell.cellReuseId, cellType: ForecastCell.self)) { _, forecastCellViewModel, cell in
                cell.drive(viewModel: forecastCellViewModel)
            }
            .disposed(by: bag)
    }
}
