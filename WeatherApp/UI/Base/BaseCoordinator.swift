//
//  BaseCoordinator.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

// Originally created by: https://github.com/uptechteam/Coordinator-MVVM-Rx-Example

import Foundation
import RxSwift

class BaseCoordinator<CoordinationResult> {

    // MARK: - Private properties
    
    private let identifier = UUID()

    /// Dictionary of child coordinators. Every child coordinator should be added to dictionary in order to keep it in memory.
    private var childCoordinators = [UUID: Any]()

    // MARK: - Public properties

    let bag = DisposeBag()

    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - parameter coordinator: Child coordinator to store.
    private func save<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Remove coordinator from the `childCoordinators` dictionary.
    ///
    /// - parameter coordinator: Coordinator to remove.
    private func free<T>(_ coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - parameter coordinator:    Coordinator to start.
    /// - returns:                  Result of `start()` method.
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        save(coordinator)

        return coordinator
            .start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator)
            })
    }

    /// Starts coordinator.
    ///
    /// - returns: Result of coordinator job.
    func start() -> Observable<CoordinationResult> {
        fatalError("Start should be implemented by subclass")
    }
}
