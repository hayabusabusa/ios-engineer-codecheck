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
    var repositoriesDriver: Driver<[Repository]> { get }
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

    var repositoriesDriver: Driver<[Repository]>
    var stateDriver: Driver<StateView.State>
    var pushRepositoryDetailSignal: Signal<Repository> {
        pushRepositoryDetailRelay.asSignal()
    }

    // MARK: Initializer

    init(model: SearchRepositoriesModelProtocol = SearchRepositoriesModel()) {
        self.model = model

        let mergedStateStream = Observable.merge(
            // NOTE: 検索後ロード中 or 検索のロードが完了が流れる
            model.isLoadingRelay.map { $0 ? StateView.State.loading : StateView.State.none },
            // NOTE: 検索結果が空の時のみイベントが流れる
            model.repositoriesRelay.filter { $0.isEmpty }.map { _ in StateView.State.empty },
            // NOTE: エラー発生時にイベントが流れる
            model.errorRelay.map { _ in StateView.State.error }
        )

        self.pushRepositoryDetailRelay = PublishRelay<Repository>()
        self.stateDriver = mergedStateStream.asDriver(onErrorDriveWith: .empty())
        self.repositoriesDriver = model.repositoriesRelay.asDriver()
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
