//
//  ImageDownload.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 11/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import RxKingfisher
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
        guard let url = imageURL(forName: name) else {
            return Single.error(RequestError.serviceUnavailable)
        }
        
        return KingfisherManager.shared.rx.retrieveImage(with: url)
    }
}
