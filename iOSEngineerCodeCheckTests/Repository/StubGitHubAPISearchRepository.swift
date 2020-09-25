//
//  StubGitHubAPISearchRepository.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
@testable import iOSEngineerCodeCheck

struct StubGitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol {
    
    // MARK: Properties
    
    private let isErrorOccurred: Bool
    
    // MARK: Initializer
    
    init(isErrorOccurred: Bool = false) {
        self.isErrorOccurred = isErrorOccurred
    }
    
    // MARK: Call API
    
    func searchRepositories(keyword: String) -> Single<SearchRepositoriesResponse> {
        return isErrorOccurred
            ? Single.error(StubError())
            : Single.just(Stubs.searchRepositoriesResponse)
    }
}
