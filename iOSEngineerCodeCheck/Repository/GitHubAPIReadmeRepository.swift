//
//  GitHubAPIReadmeRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift

protocol GitHubAPIReadmeRepositoryProtocol {
    func fetchReadme(of repository: Repository) -> Single<String?>
}

struct GitHubAPIReadmeRepository: GitHubAPIReadmeRepositoryProtocol {
    
    // MARK: Dependency
    
    private let apiClient: APIClientProtocol
    
    // MARK: Initializer
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: Call API
    
    func fetchReadme(of repository: Repository) -> Single<String?> {
        return apiClient.call(with: GetReadmeRequest(ownerName: repository.owner.login, repositoryName: repository.name))
    }
}
