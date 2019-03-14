//
//  BaseController.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

struct AlertMessage {
    let title: String
    let message: String
    let dismissTitle: String
}

/**
 Base controller. Tracks RxSwift.Resources count. Has the ability to drive
 alert messages and has observable property for popping from the navigation stack (useful in coordinators).
**/
class BaseController: UIViewController {

    // MARK: - Private properties

    #if DEBUG
        private let startResourceCount = Resources.total
    #endif

    // MARK: - Public properties

    lazy var poppedFromNavigationStack = PublishSubject<Void>()
    lazy var alertMessage = PublishSubject<AlertMessage>()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
            let logString = "⚠️ Number of start resources = \(Resources.total) ⚠️"
            print(logString)
        #endif

        alertMessage
            .flatMap { [unowned self] in
                self.presentAlert($0)
            }
            .subscribe()
            .disposed(by: bag)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent {
            poppedFromNavigationStack.onNext(())
            poppedFromNavigationStack.onCompleted()
        }
    }

    deinit {
        #if DEBUG

            let mainQueue = DispatchQueue.main
            let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(300)

            mainQueue.asyncAfter (deadline: when) {
                let logString = "⚠️ Number of resources after dispose = \(Resources.total) ⚠️"
                print(logString)
            }

            /*
             !!! In case you want to have some resource leak detection logic, the simplest
             method is just printing out `RxSwift.Resources.total` periodically to output. !!!

             /* add somewhere in
             func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
             */
             _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
             .subscribe(onNext: { _ in
             print("Resource count \(RxSwift.Resources.total)")
             })

             Most efficient way to test for memory leaks is:
             * navigate to your screen and use it
             * navigate back
             * observe initial resource count
             * navigate second time to your screen and use it
             * navigate back
             * observe final resource count

             In case there is a difference in resource count between initial and final resource counts, there might be a memory
             leak somewhere.

             The reason why 2 navigations are suggested is because first navigation forces loading of lazy resources.
             */

        #endif
    }
}
