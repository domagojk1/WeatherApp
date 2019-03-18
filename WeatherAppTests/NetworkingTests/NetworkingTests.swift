//
//  NetworkingTests.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 11/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import XCTest
import RxBlocking
import Nimble
@testable import WeatherApp

class NetworkingTests: XCTestCase {

    private let openWeatherClient = NetworkingMocks.openWeatherImmediateClient
    private let openWeatherErrorClient = NetworkingMocks.openWeatherImmediateErrorClient()

    override func setUp() {
    }

    override func tearDown() {
    }

    func testIsWeatherRequestSuccessful() throws {
        guard let result = try openWeatherClient.weather(for: "London").toBlocking().first() else {
            preconditionFailure("OpenWeatherClient test failed: data unavailable.")
        }

        switch result {
        case .success(let weather):
            expect(weather).to(equal(Decoded.weather))
        case .error:
            fail("OpenWeatherClient test failed: request error.")
        }
    }

    func testDidWeatherRequestFail() throws {
        guard let result = try openWeatherErrorClient.weather(for: "London").toBlocking().first() else {
            preconditionFailure("OpenWeatherClient test failed: data unavailable.")
        }

        switch result {
        case .success:
            fail("OpenWeatherClient test failed: weather should not be available")
        case .error(let error):
            expect(error).to(matchError(RequestError.serverError))
        }
    }

    func testIsForecastRequestSuccessful() throws {
        guard let result = try openWeatherClient.forecast(for: "London").toBlocking().first() else {
            preconditionFailure("OpenWeatherClient test failed: data unavailable.")
        }

        switch result {
        case .success(let forecast):
            expect(forecast).to(equal(Decoded.forecast))
        case .error:
            fail("OpenWeatherClient test failed: request error.")
        }
    }

    func testDidForecastRequestFail() throws {
        guard let result = try openWeatherErrorClient.forecast(for: "London").toBlocking().first() else {
            preconditionFailure("OpenWeatherClient test failed: data unavailable.")
        }

        switch result {
        case .success:
            fail("OpenWeatherClient test failed: weather should not be available")
        case .error(let error):
            expect(error).to(matchError(RequestError.serverError))
        }
    }
}
