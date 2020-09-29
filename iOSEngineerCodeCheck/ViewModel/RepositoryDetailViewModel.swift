//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RepositoryDetailViewModelInput {
    func tappedLinkButton(url: String)
}

protocol RepositoryDetailViewModelOutput {
    var repositoryDriver: Driver<Repository> { get }
    var presentSafariSignal: Signal<URL> { get }
}

protocol RepositoryDetailViewModelType {
    var input: RepositoryDetailViewModelInput { get }
    var output: RepositoryDetailViewModelOutput { get }
}

final class RepositoryDetailViewModel: RepositoryDetailViewModelInput, RepositoryDetailViewModelOutput {

    // MARK: Dependency

    private let repository: Repository

    // MARK: Properties

    var repositoryDriver: Driver<Repository>
    var presentSafariSignal: Signal<URL>

    private let urlRelay: PublishRelay<URL>

    // MARK: Initializer

    init(repository: Repository) {
        self.repository = repository
        self.urlRelay = PublishRelay<URL>()
        self.repositoryDriver = BehaviorRelay<Repository>(value: repository).asDriver()
        self.presentSafariSignal = urlRelay.asSignal()
    }

    // MARK: Trigger

    func tappedLinkButton(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        urlRelay.accept(url)
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var input: RepositoryDetailViewModelInput { self }
    var output: RepositoryDetailViewModelOutput { self }
}
