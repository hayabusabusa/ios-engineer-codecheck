//
//  SearchRepositoriesViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/26.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchRepositoriesViewModelInput {
    func searchBarSearchButtonClicked(keyword: String)
    func didSelectRow(at indexPath: IndexPath)
    func didReachBottom()
}

protocol  SearchRepositoriesViewModelOutput {
    var dataSourceDriver: Driver<[SearchRepositoriesCellType]> { get }
    var stateDriver: Driver<StateView.State> { get }
    var pushRepositoryDetailSignal: Signal<Repository> { get }
}

protocol  SearchRepositoriesViewModelType {
    var input: SearchRepositoriesViewModelInput { get }
    var output: SearchRepositoriesViewModelOutput { get }
}

final class SearchRepositoriesViewModel: SearchRepositoriesViewModelInput, SearchRepositoriesViewModelOutput {

    // MARK: Dependency

    private let model: SearchRepositoriesModelProtocol

    // MARK: Properties

    private let pushRepositoryDetailRelay: PublishRelay<Repository>

    // MARK: Output

    var dataSourceDriver: Driver<[SearchRepositoriesCellType]>
    var stateDriver: Driver<StateView.State>
    var pushRepositoryDetailSignal: Signal<Repository> {
        pushRepositoryDetailRelay.asSignal()
    }

    // MARK: Initializer

    init(model: SearchRepositoriesModelProtocol = SearchRepositoriesModel()) {
        self.model = model

        let zippedDataSourceStream = Observable.zip(
            model.repositoriesRelay,
            model.isReachLastPageRelay
        )
        .map { repositories, isReachLastPage -> [SearchRepositoriesCellType] in
            // NOTE: 取得したリポジトリ一覧 + 最終ページに到達していない場合はインジケータのセルの配列にマップ
            let items = repositories.map { SearchRepositoriesCellType.item(with: $0) }
            return items + (isReachLastPage ? [] : [SearchRepositoriesCellType.indicator])
        }

        let mergedStateStream = Observable.merge(
            // NOTE: 検索後ロード中 or 検索のロードが完了が流れる
            model.isLoadingRelay.map { $0 ? StateView.State.loading : StateView.State.none },
            // NOTE: 検索結果が空の時のみイベントが流れる
            model.repositoriesRelay.filter { $0.isEmpty }.map { _ in StateView.State.empty },
            // NOTE: エラー発生時にイベントが流れる
            model.errorRelay.map { _ in StateView.State.error }
        )

        self.dataSourceDriver = zippedDataSourceStream.asDriver(onErrorDriveWith: .empty())
        self.stateDriver = mergedStateStream.asDriver(onErrorDriveWith: .empty())
        self.pushRepositoryDetailRelay = PublishRelay<Repository>()
    }

    // MARK: Trigger

    func searchBarSearchButtonClicked(keyword: String) {
        model.fetchRepositories(with: keyword)
    }

    func didSelectRow(at indexPath: IndexPath) {
        pushRepositoryDetailRelay.accept(model.repositoriesRelay.value[indexPath.row])
    }

    func didReachBottom() {
        model.fetchNextPage()
    }
}

extension SearchRepositoriesViewModel: SearchRepositoriesViewModelType {
    var input: SearchRepositoriesViewModelInput { self }
    var output: SearchRepositoriesViewModelOutput { self }
}
