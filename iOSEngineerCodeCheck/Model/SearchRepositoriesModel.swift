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

    /// 検索後実行後のロード中かどうかを表すフラグが流れてくる `PublishRelay`
    var isLoadingRelay: PublishRelay<Bool> { get }

    /// 通信時等にエラーが発生した場合にエラーが流れる `PublishRelay`
    var errorRelay: PublishRelay<Error> { get }

    /// GitHub の API `/search/repositories` へリクエストを送信する
    /// - Parameter keyword: 検索時に使用するキーワード
    func fetchRepositories(with keyword: String)

    /// 現在の検索結果の次のページを取得する
    func fetchNextPage()
}

final class SearchRepositoriesModel: SearchRepositoriesModelProtocol {

    // MARK: Dependency

    private let gitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol

    // MARK: Properties

    var repositoriesRelay = BehaviorRelay<[Repository]>(value: [])
    var isLoadingRelay = PublishRelay<Bool>()
    var errorRelay = PublishRelay<Error>()

    private var keyword = ""
    private var currentPage = 1
    private var isReachLastPage = false
    private var isFetchingNextPage = false

    private let disposeBag = DisposeBag()

    // MARK: Initializer

    init(gitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol = GitHubAPISearchRepository()) {
        self.gitHubAPISearchRepository = gitHubAPISearchRepository
    }

    // MARK: Call API

    func fetchRepositories(with keyword: String) {
        isLoadingRelay.accept(true)
        gitHubAPISearchRepository.searchRepositories(keyword: keyword, page: currentPage)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.keyword = keyword
                self.isReachLastPage = response.totalCount == self.currentPage
                self.isLoadingRelay.accept(false)
                self.repositoriesRelay.accept(response.items)
            }, onError: { [weak self] error in
                self?.isLoadingRelay.accept(false)
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func fetchNextPage() {
        guard !isFetchingNextPage && !isReachLastPage && !keyword.isEmpty else {
            return
        }

        isFetchingNextPage = true

        let nextPage = currentPage + 1
        gitHubAPISearchRepository.searchRepositories(keyword: keyword, page: nextPage)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.currentPage = nextPage
                self.isReachLastPage = response.totalCount == self.currentPage
                self.isFetchingNextPage = false
                self.repositoriesRelay.accept(self.repositoriesRelay.value + response.items)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
