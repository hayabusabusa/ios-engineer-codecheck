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
}

protocol  SearchRepositoriesViewModelOutput {
    var repositoriesDriver: Driver<[Repository]> { get }
}

protocol  SearchRepositoriesViewModelType {
    var input: SearchRepositoriesViewModelInput { get }
    var output: SearchRepositoriesViewModelOutput { get }
}

final class SearchRepositoriesViewModel: SearchRepositoriesViewModelInput, SearchRepositoriesViewModelOutput {
    
    // MARK: Dependency
    
    private let model: SearchRepositoriesModelProtocol
    
    // MARK: Properties
    
    var repositoriesDriver: Driver<[Repository]>
    
    // MARK: Initializer
    
    init(model: SearchRepositoriesModelProtocol = SearchRepositoriesModel()) {
        self.model = model
        self.repositoriesDriver = model.repositoriesRelay.asDriver()
    }
    
    // MARK: Trigger
    
    func searchBarSearchButtonClicked(keyword: String) {
        model.fetchRepositories(with: keyword)
    }
}

extension SearchRepositoriesViewModel: SearchRepositoriesViewModelType {
    var input: SearchRepositoriesViewModelInput { self }
    var output: SearchRepositoriesViewModelOutput { self }
}
