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

    /// ページネーションのページ数が最後のページに到達したかどうかを表すフラグが流れる `BehaviorRelay`
    /// - NOTE: 初回サブスクライブ時にページネーションのインジケーターを非表示にしたいため初期値 `true` で流す.
    var isReachLastPageRelay: BehaviorRelay<Bool> { get }

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
    var isReachLastPageRelay = BehaviorRelay<Bool>(value: true)
    var isLoadingRelay = PublishRelay<Bool>()
    var errorRelay = PublishRelay<Error>()

    private var keyword = ""
    private var currentPage = 1
    private var isFetchingNextPage = false

    private let disposeBag = DisposeBag()

    // MARK: Initializer

    init(gitHubAPISearchRepository: GitHubAPISearchRepositoryProtocol = GitHubAPISearchRepository()) {
        self.gitHubAPISearchRepository = gitHubAPISearchRepository
    }

    // MARK: Call API

    func fetchRepositories(with keyword: String) {
        isLoadingRelay.accept(true)
        gitHubAPISearchRepository.searchRepositories(keyword: keyword, page: 1)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.keyword = keyword
                self.currentPage = 1
                self.isLoadingRelay.accept(false)
                // NOTE: 検索結果がない場合は `total_count` が `0` で返ってくるので、空の場合も考慮する.
                self.isReachLastPageRelay.accept(response.totalCount <= self.currentPage)
                self.repositoriesRelay.accept(response.items)
            }, onError: { [weak self] error in
                self?.isLoadingRelay.accept(false)
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func fetchNextPage() {
        guard !isFetchingNextPage && !isReachLastPageRelay.value && !keyword.isEmpty else {
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
                self.isFetchingNextPage = false
                self.isReachLastPageRelay.accept(response.totalCount == self.currentPage)
                self.repositoriesRelay.accept(self.repositoriesRelay.value + response.items)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
