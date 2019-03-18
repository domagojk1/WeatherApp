//
//  ImageDownloaderMock.swift
//  WeatherAppTests
//
//  Created by UHP Mac 7 on 12/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
@testable import WeatherApp

class ImageDownloaderMock: ImageDownloadable {
    var shouldFail = false
    let downloadedImage = UIImage()

    func image(forName name: String) -> Single<UIImage> {
        return Single.create { single in
            if self.shouldFail {
                single(.error(RequestError.serverError))
            } else {
                single(.success(self.downloadedImage))
            }

            return Disposables.create()
        }
    }
}

