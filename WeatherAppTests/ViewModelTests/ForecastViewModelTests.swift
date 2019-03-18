//
//  ForecastViewModelTests.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 18/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import Nimble
@testable import WeatherApp

class ForecastViewModelTests: XCTestCase {

    private var scheduler: TestScheduler!
    private var bag: DisposeBag!

    private var imageDownloader: ImageDownloaderMock!
    private var openWeatherErrorClient: OpenWeatherClient!
    private var openWeatherClient: OpenWeatherClient!

    private var viewModel: ForecastViewModel!
    private var viewModelWithErrorClient: ForecastViewModel!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        bag = DisposeBag()

        imageDownloader = ImageDownloaderMock()
        openWeatherErrorClient = NetworkingMocks.openWeatherImmediateErrorClient()
        openWeatherClient = NetworkingMocks.openWeatherImmediateClient

        SharingScheduler.mock(scheduler: scheduler) {
            viewModel = ForecastViewModel(city: "",
                                          openWeatherClient: openWeatherClient,
                                          imageDownloader: imageDownloader)

            viewModelWithErrorClient = ForecastViewModel(city: "",
                                                         openWeatherClient: openWeatherErrorClient,
                                                         imageDownloader: imageDownloader)
        }
    }

    override func tearDown() {
    }

    func testIsForecastDataAvailable() throws {
        let forecastObserver = scheduler.createObserver([ForecastCellViewModel].self)

        viewModel.dailyForecast.drive(forecastObserver).disposed(by: bag)

        let correctEvents = Recorded.events(
            .next(1, Decoded.expectedCellViewModels),
            .completed(2)
        )

        scheduler.start()

        expect(forecastObserver.events).to(equal(correctEvents))
    }

    func testIsForecastUnavailable() {
        let forecastObserver = scheduler.createObserver([ForecastCellViewModel].self)

        viewModelWithErrorClient.dailyForecast.drive(forecastObserver).disposed(by: bag)

        scheduler.start()

        expect(forecastObserver.events).to(equal([Recorded.completed(2)]))
    }

    func testIsLoading() {
        let isLoadingObserver = scheduler.createObserver(Bool.self)

        viewModel.isLoading.drive(isLoadingObserver).disposed(by: bag)

        let correctEvents = Recorded.events(
            .next(0, true),
            .next(1, false),
            .completed(2)
        )

        scheduler.start()

        expect(isLoadingObserver.events).to(equal(correctEvents))
    }

    func testIfDidFailIsEmpty() {
        let didFailObserver = scheduler.createObserver(AlertMessage.self)

        viewModel.didFail.drive(didFailObserver).disposed(by: bag)

        scheduler.start()

        expect(didFailObserver.events).to(equal([Recorded.completed(2)]))
    }

    func testDidFail() {
        let didFailObserver = scheduler.createObserver(AlertMessage.self)

        viewModelWithErrorClient.didFail.drive(didFailObserver).disposed(by: bag)

        scheduler.start()

        let correctEvents = Recorded.events(
            .next(1, ForecastViewModel.forecastUnavailableMessage),
            .completed(2)
        )

        expect(didFailObserver.events).to(equal(correctEvents))
    }
}
