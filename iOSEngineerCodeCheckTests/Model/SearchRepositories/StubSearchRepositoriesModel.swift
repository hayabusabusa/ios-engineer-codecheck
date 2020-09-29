//
//  StubSearchRepositoriesModel.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/26.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
import RxRelay
@testable import iOSEngineerCodeCheck

final class StubSearchRepositoriesModel: SearchRepositoriesModelProtocol {
    
    // MARK: Properties
    
    var isLoadingRelay = PublishRelay<Bool>()
    var repositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    var errorRelay = PublishRelay<Error>()
    
    private let isErrorOccured: Bool
    
    // MARK: Initializer
    
    init(isErrorOccured: Bool = false) {
        self.isErrorOccured = isErrorOccured
    }
    
    // MARK: Call API
    
    func fetchRepositories(with keyword: String) {
        isLoadingRelay.accept(true)
        isErrorOccured
            ? errorRelay.accept(StubError())
            : repositoriesRelay.accept([Stubs.repository])
        isLoadingRelay.accept(false)
    }
    
    func fetchNextPage() {
        repositoriesRelay.accept(repositoriesRelay.value + [Stubs.repository])
    }
}
