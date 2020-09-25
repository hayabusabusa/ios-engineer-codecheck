//
//  SearchRepositoriesModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
import RxRelay

protocol SearchRepositoriesModelProtocol: AnyObject {
    /// GitHub の API `/search/repositories` から返ってきたリポジトリ一覧が流れる `BehaviorRelay`
    var repositoriesRelay: BehaviorRelay<[Repository]> { get }
    
    /// GitHub の API `/search/repositories` へリクエストを送信する
    /// - Parameter keyword: 検索時に使用するキーワード
    func fetchRepositories(with keyword: String)
}

final class SearchRepositoriesModel: SearchRepositoriesModelProtocol {
    
    // MARK: Dependency
    
    private let gitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol
    
    // MARK: Properties
    
    var repositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(gitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol = GitHubAPISearchRepository()) {
        self.gitHubAPISearchRepository = gitHubAPISearchRepository
    }
    
    // MARK: Call API
    
    func fetchRepositories(with keyword: String) {
        gitHubAPISearchRepository.searchRepositories(keyword: keyword)
            .subscribe(onSuccess: { [weak self] response in
                self?.repositoriesRelay.accept(response.items)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
