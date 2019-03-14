//
//  ImageDownload.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 11/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher

protocol ImageDownloadable {
    func image(forName name: String) -> Single<UIImage>
}

class ImageDownloader: ImageDownloadable {

    static let imageBaseURL = "https://api.openweathermap.org/img/w/"

    private func imageURL(forName name: String) -> URL? {
        return URL(string: "\(ImageDownloader.imageBaseURL)\(name).png")
    }

    func image(forName name: String) -> Single<UIImage> {
        return Single.create { single in

            if let url = self.imageURL(forName: name) {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        single(.success(value.image))
                    case .failure(let error):
                        single(.error(error))
                    }
                }
            } else {
                single(.error(RequestError.serviceUnavailable))
            }

            return Disposables.create()
        }
    }
}
