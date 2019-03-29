//
//  APIClient.swift
//  WeatherApp
//
//  Created by UHP Mac 7 on 06/03/2019.
//  Copyright © 2019 UHP. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class APIClient<T: TargetType> {
    private let provider: MoyaProvider<T>

    init(provider: MoyaProvider<T>) {
        self.provider = provider
    }

    func request<Response>(target: T) -> Single<APIResult<Response>> {
        return provider
            .rx
            .request(target)
            .filterSuccessfulStatusCodes()
            .map(Response.self)
            .map { response in
                return .success(response)
            }
            .catchError { error in
                guard let statusCode = (error as? MoyaError)?.response?.statusCode else {
                    return Single.just(.error(.undefined))
                }

                let requestError = RequestError(rawValue: statusCode) ?? .undefined
                return Single.just(.error(requestError))
            }
    }
}
