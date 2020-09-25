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
    
    func searchRepositories(keyword: String) -> Single<SearchRepositoriesResponse> {
        return Single.just(SearchRepositoriesResponse(totalCount: 1,
                                                      items: [
                                                        Repository(fullName: "Stub",
                                                                   owner: RepositoryOwner(avatarURL: "Stub"),
                                                                   stargazersCount: 1,
                                                                   watchersCount: 1,
                                                                   language: "Stub",
                                                                   forksCount: 1,
                                                                   openIssueCount: 1)
                                                      ]))
    }
}
