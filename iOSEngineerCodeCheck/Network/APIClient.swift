//
//  APIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Alamofire
import RxSwift

protocol APIClientProtocol: AnyObject {
    func call<T: APIRequest>(with request: T) -> Single<T.Response>
    func call<T: APICustomDecodeRequest>(with request: T) -> Single<T.Response>
}

final class APIClient: APIClientProtocol {

    // MARK: Singleton

    static let shared: APIClient = .init()

    // MARK: Initializer

    private init() {}

    // MARK: Call

    func call<T: APIRequest>(with request: T) -> Single<T.Response> {
        Single.create { observer in
            let url = request.endpoint + request.path
            let request = AF.request(url,
                                     method: request.method,
                                     parameters: request.parameters,
                                     encoding: request.encoding,
                                     headers: request.headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        do {
                            guard let data = response.data else {
                                return
                            }
                            let object = try JSONDecoder().decode(T.Response.self, from: data)
                            observer(.success(object))
                        } catch {
                            observer(.error(error))
                        }
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func call<T: APICustomDecodeRequest>(with request: T) -> Single<T.Response> {
        Single.create { observer in
            let url = request.endpoint + request.path
            let request = AF.request(url,
                                     method: request.method,
                                     parameters: request.parameters,
                                     encoding: request.encoding,
                                     headers: request.headers)
                .response { response in
                    switch response.result {
                    case .success:
                        do {
                            let object = try request.decode(from: response.data)
                            observer(.success(object))
                        } catch {
                            observer(.error(error))
                        }
                    case .failure(let error):
                        observer(.error(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
