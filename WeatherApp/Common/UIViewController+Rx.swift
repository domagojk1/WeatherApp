//
//  UIViewController+Rx.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 13/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {

    func presentAlert(_ alertMessage: AlertMessage) -> Completable {
        return Completable.create { completable in
            
            guard self.presentedViewController == nil else {
                completable(.completed)
                return Disposables.create()
            }

            let alert = UIAlertController(title: alertMessage.title,
                                          message: alertMessage.message,
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: alertMessage.dismissTitle, style: .default) { _ in
                completable(.completed)
            })

            self.present(alert, animated: true)

            return Disposables.create {
                alert.dismiss(animated: true)
            }
        }
    }
}
