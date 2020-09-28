//
//  RepositoryDetailModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxRelay
import RxSwift

protocol RepositoryDetailModelProtocol: AnyObject {
    /// GitHub リポジトリの `README.md` のテキストが流れてくる `PublishRelay`.
    /// 取得できなかった場合は `nil` が流れてくる.
    var readmeRelay: PublishRelay<String?> { get }
    
    
    /// GitHub リポジトリから `README.md` ファイルを取得する.
    /// - Parameter repository: 取得したいリポジトリの情報
    func fetchReadme(of repository: Repository)
}

final class RepositoryDetailModel: RepositoryDetailModelProtocol {
    
    // MARK: Dependency
    
    private let gitHubAPIReadmeRepository: GitHubAPIReadmeRepositoryProtocol
    
    // MARK: Properties
    
    var readmeRelay = PublishRelay<String?>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(gitHubAPIReadmeRepository: GitHubAPIReadmeRepositoryProtocol = GitHubAPIReadmeRepository()) {
        self.gitHubAPIReadmeRepository = gitHubAPIReadmeRepository
    }
    
    // MARK: Call API
    
    func fetchReadme(of repository: Repository) {
        gitHubAPIReadmeRepository.fetchReadme(of: repository)
            .subscribe(onSuccess: { [weak self] readmeString in
                self?.readmeRelay.accept(readmeString)
            }, onError: { [weak self] error in
                self?.readmeRelay.accept(nil)
            })
            .disposed(by: disposeBag)
    }
}
