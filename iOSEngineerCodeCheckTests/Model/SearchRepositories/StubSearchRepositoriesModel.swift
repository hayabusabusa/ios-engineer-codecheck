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
    var isReachLastPageRelay = BehaviorRelay<Bool>(value: true)
    var repositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    var errorRelay = PublishRelay<Error>()
    
    private let isErrorOccured: Bool
    private let isRepositoriesEmpty: Bool
    private var numberOfPage: Int
    
    private var currentPage = 1
    
    // MARK: Initializer
    
    init(isErrorOccured: Bool = false, isRepositoriesEmpty: Bool = false, numberOfPage: Int = 2) {
        self.isErrorOccured = isErrorOccured
        self.isRepositoriesEmpty = isRepositoriesEmpty
        self.numberOfPage = numberOfPage
    }
    
    // MARK: Call API
    
    func fetchRepositories(with keyword: String) {
        currentPage = 1
        isLoadingRelay.accept(true)
        isLoadingRelay.accept(false)
        isReachLastPageRelay.accept(false)
        isErrorOccured
            ? errorRelay.accept(StubError())
            : repositoriesRelay.accept(isRepositoriesEmpty ? [] : [Stubs.repository])
    }
    
    func fetchNextPage() {
        guard !isReachLastPageRelay.value else {
            return
        }
        currentPage += 1
        isReachLastPageRelay.accept(currentPage == numberOfPage)
        repositoriesRelay.accept(repositoriesRelay.value + [Stubs.repository])
    }
}
