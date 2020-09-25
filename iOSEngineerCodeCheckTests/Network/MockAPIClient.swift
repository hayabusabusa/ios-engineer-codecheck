//
//  MockAPIClient.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
@testable import iOSEngineerCodeCheck

final class MockAPIClient: APIClientProtocol {
    
    // MARK: Singleton
    
    static let shared: MockAPIClient = .init()
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Call API
    
    func call<T: APIRequest>(with request: T) -> Single<T.Response> {
        guard let sampleData = request.sampleData else {
            fatalError("SampleData is required on unit test.")
        }
        return Single.just(sampleData)
    }
}
