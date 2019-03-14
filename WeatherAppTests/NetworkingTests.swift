//
//  NetworkingTests.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 11/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import XCTest
import Moya
@testable import WeatherApp

class NetworkingTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testOpenWeatherClientSuccess() throws {
        let client = NetworkingMocks.openWeatherImmediateClient

        guard let result = try client.weather(for: "London").toBlocking().first() else {
            XCTFail("OpenWeatherClient test failed: data unavailable.")
            return
        }

        switch result {
        case .success(let weather):
            XCTAssertEqual(weather.name, "London")
        case .error:
            XCTFail("OpenWeatherClient test failed: request error.")
        }
    }

    func testOpenWeatherClientError() throws {
        let client = NetworkingMocks.openWeatherImmediateErrorClient(
            responseCode: NetworkingMocks.serverErrorResponseCode,
            responseData: NetworkingMocks.emptyDataResponse
        )

        guard let result = try client.weather(for: "London").toBlocking().first() else {
            XCTFail("OpenWeatherClient test failed: data unavailable.")
            return
        }

        switch result {
        case .success:
            XCTFail("OpenWeatherClient test failed: weather should not be available")
        case .error(let error):
            XCTAssertEqual(error.rawValue, NetworkingMocks.serverErrorResponseCode)
        }
    }
}
