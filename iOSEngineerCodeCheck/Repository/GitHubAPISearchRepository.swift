//
//  GitHubAPISearchRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift

protocol GitHubAPISearchRepositoryProtocol {
    func searchRepositories(keyword: String) -> Single<SearchRepositoriesResponse>
}

struct GitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol {

    // MARK: Dependency

    private let apiClient: APIClientProtocol

    // MARK: Initializer

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    // MARK: Call API

    func searchRepositories(keyword: String) -> Single<SearchRepositoriesResponse> {
        apiClient.call(with: SearchRepositoriesRequest(keyword: keyword))
    }
}
