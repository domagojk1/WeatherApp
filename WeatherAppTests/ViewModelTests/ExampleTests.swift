//
//  ExampleTests.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 28/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Nimble
@testable import WeatherApp

class ExampleTests: XCTestCase {
    private var scheduler: TestScheduler!
    private let disposeBag = DisposeBag()

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
    }

    func testRetryWhenOnlyErrorExample() {
        let original: TestableObservable<Int> = scheduler.createColdObservable([
            .error(1, RequestError.badRequest)
            ])

        let result = scheduler.start {
            original.retry(3)
        }

        let correctEvents: [Recorded<Event<Int>>] = [
            .error(203, RequestError.badRequest)
        ]

        let correctSubscriptions = [
            Subscription(200, 201),
            Subscription(201, 202),
            Subscription(202, 203),
        ]

        expect(result.events).to(equal(correctEvents))
        expect(original.subscriptions).to(equal(correctSubscriptions))
    }

    func testRetryErrorNotReceivedExample() {
        let original: TestableObservable<Int> = scheduler.createHotObservable([
            .error(201, RequestError.badRequest),
            .next(400, 1),
            .completed(401)
            ])

        let result = scheduler.start {
            original.retry(2)
        }

        let correctEvents: [Recorded<Event<Int>>] = [
            .next(400, 1),
            .completed(401)
        ]

        let correctSubscriptions = [
            Subscription(200, 201),
            Subscription(201, 401)
        ]

        expect(result.events).to(equal(correctEvents))
        expect(original.subscriptions).to(equal(correctSubscriptions))
    }
}
