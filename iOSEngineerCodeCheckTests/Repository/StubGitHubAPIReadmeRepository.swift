//
//  StubGitHubAPIReadmeRepository.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
@testable import iOSEngineerCodeCheck

struct StubGitHubAPIReadmeRepository: GitHubAPIReadmeRepositoryProtocol {
    
    // MARK: Properties
    
    private let isErrorOccurred: Bool
    
    // MARK: Initializer
    
    init(isErrorOccurred: Bool = false) {
        self.isErrorOccurred = isErrorOccurred
    }
    
    // MARK: Call API
    
    func fetchReadme(of repository: Repository) -> Single<String?> {
        return isErrorOccurred ? Single.just(nil) : Single.just("Stub")
    }
}
