//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import Nimble
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {

    private var scheduler: TestScheduler!
    private var bag: DisposeBag!
    
    private var imageDownloader: ImageDownloaderMock!
    private var viewModel: WeatherViewModel!
    private var viewModelWithErrorClient: WeatherViewModel!

    override func setUp() {
        bag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        imageDownloader = ImageDownloaderMock()
    }

    func testIsDataAvailableWithInitialCity() {
        mockViewModel(with: "London")

        let isLoadingObservable = scheduler.createObserver(Bool.self)

        viewModel.isLoading.drive(isLoadingObservable).disposed(by: bag)

        let weatherModelObservable = scheduler.createObserver(WeatherModel.self)

        viewModel.weatherModel.drive(weatherModelObservable).disposed(by: bag)

        let correctLoadingEvents = Recorded.events(
            .next(1, true),
            .next(2, false)
        )

        scheduler.start()

        expect(isLoadingObservable.events).to(equal(correctLoadingEvents))
        expect(weatherModelObservable.events.count).to(equal(1))
    }

    func testIsDataNotAvailableWithInitialCity() {
        mockErrorViewModel(with: "London")

        let isLoadingObservable = scheduler.createObserver(Bool.self)

        viewModelWithErrorClient.isLoading.drive(isLoadingObservable).disposed(by: bag)

        let weatherModelObservable = scheduler.createObserver(WeatherModel.self)

        viewModelWithErrorClient.weatherModel.drive(weatherModelObservable).disposed(by: bag)

        let correctLoadingEvents = Recorded.events(
            .next(1, true),
            .next(2, false)
        )

        scheduler.start()

        expect(isLoadingObservable.events).to(equal(correctLoadingEvents))
        expect(weatherModelObservable.events).to(beEmpty())
    }

    func testIsLoadingWhenSearching() {
        mockViewModel()

        let isLoadingObservable = scheduler.createObserver(Bool.self)

        viewModel.isLoading.drive(isLoadingObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(1, "Zagreb"),
                                       .next(5, "London"),
                                       .next(10, "Frankfurt")])
            .bind(to: viewModel.city)
            .disposed(by: bag)

        let correctLoadingEvents = Recorded.events(
            .next(3, true),
            .next(4, false),
            .next(7, true),
            .next(8, false),
            .next(12, true),
            .next(13, false)
        )

        scheduler.start()

        expect(isLoadingObservable.events).to(equal(correctLoadingEvents))
    }

    func testIsNotLoadingWhenSearchingSameCity() {
        mockViewModel()

        let isLoadingObservable = scheduler.createObserver(Bool.self)

        viewModel.isLoading.drive(isLoadingObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(1, "London"),
                                       .next(5, "London")])
            .bind(to: viewModel.city)
            .disposed(by: bag)

        let correctLoadingEvents = Recorded.events(
            .next(3, true),
            .next(4, false)
        )

        scheduler.start()

        expect(isLoadingObservable.events).to(equal(correctLoadingEvents))
    }

    func testIsNotLoadingWhenIntervalNotSatisfied() {
        mockViewModel()

        let isLoadingObservable = scheduler.createObserver(Bool.self)

        viewModel.isLoading.drive(isLoadingObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(0, "London0"),
                                       .next(1, "London1"),
                                       .next(2, "London2")])
            .bind(to: viewModel.city)
            .disposed(by: bag)

        let correctLoadingEvents = Recorded.events(
            .next(4, true),
            .next(5, false)
        )

        scheduler.start()

        expect(isLoadingObservable.events).to(equal(correctLoadingEvents))
    }

    func testIfDidFailIsEmpty() {
        mockViewModel()

        let didFailObservable = scheduler.createObserver(AlertMessage.self)

        viewModel.didFail.drive(didFailObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(0, "London"),
                                       .next(5, "Zagreb")])
            .bind(to: viewModel.city)
            .disposed(by: bag)

        scheduler.start()

        expect(didFailObservable.events).to(beEmpty())
    }

    func testDidFail() {
        mockErrorViewModel()

        let didFailObservable = scheduler.createObserver(AlertMessage.self)

        viewModelWithErrorClient.didFail.drive(didFailObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(0, "London"),
                                       .next(5, "Zagreb")])
            .bind(to: viewModelWithErrorClient.city)
            .disposed(by: bag)

        scheduler.start()

        let correctFailedEvents = Recorded.events(
            .next(3, WeatherViewModel.weatherUnavailableMessage),
            .next(8, WeatherViewModel.weatherUnavailableMessage)
        )

        expect(didFailObservable.events).to(equal(correctFailedEvents))
    }

    func testIsWeatherImageAvailable() {
        mockViewModel()
        imageDownloader.shouldFail = false

        let imageObservable = scheduler.createObserver(UIImage.self)

        viewModel.weatherImage.drive(imageObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(1, "London")])
            .bind(to: viewModel.city)
            .disposed(by: bag)

        scheduler.start()

        let correctImageEvents = Recorded.events(
            .next(5, imageDownloader.downloadedImage)
        )

        expect(imageObservable.events).to(equal(correctImageEvents))
    }

    func testIsWeatherImageWithPlaceholder() {
        mockViewModel()
        imageDownloader.shouldFail = true

        let imageObservable = scheduler.createObserver(UIImage.self)

        viewModel.weatherImage.drive(imageObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(0, "London")])
            .bind(to: viewModel.city)
            .disposed(by: bag)

        scheduler.start()

        let weatherImage = imageObservable.events.first?.value.element

        expect(weatherImage?.pngData()).to(equal(UIImage.weatherImagePlaceholder.pngData()))
    }

    func testIsWeatherImageUnavailable() {
        mockErrorViewModel()

        let imageObservable = scheduler.createObserver(UIImage.self)

        viewModelWithErrorClient.weatherImage.drive(imageObservable).disposed(by: bag)

        scheduler.createHotObservable([.next(0, "London")])
            .bind(to: viewModelWithErrorClient.city)
            .disposed(by: bag)

        scheduler.start()

        expect(imageObservable.events).to(beEmpty())
    }
}

extension WeatherViewModelTests {

    private func mockViewModel(with city: String = "") {
        SharingScheduler.mock(scheduler: scheduler) {
            viewModel = WeatherViewModel(initialCity: city,
                                         openWeatherClient: NetworkingMocks.openWeatherImmediateClient,
                                         scheduler: scheduler,
                                         imageDownloader: imageDownloader)
        }
    }

    private func mockErrorViewModel(with city: String = "") {
        SharingScheduler.mock(scheduler: scheduler) {
            viewModelWithErrorClient = WeatherViewModel(initialCity: city,
                                         openWeatherClient: NetworkingMocks.openWeatherImmediateErrorClient(),
                                         scheduler: scheduler,
                                         imageDownloader: imageDownloader)
        }
    }
}
