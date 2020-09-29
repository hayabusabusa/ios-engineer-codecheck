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
    var pushRepositoryDetailSignal: Signal<Repository> {
        pushRepositoryDetailRelay.asSignal()
    }

    // MARK: Initializer

    init(model: SearchRepositoriesModelProtocol = SearchRepositoriesModel()) {
        self.model = model
        self.pushRepositoryDetailRelay = PublishRelay<Repository>()
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
