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
    func viewDidLoad()
}

protocol RepositoryDetailViewModelOutput {
    var repositorySignal: Driver<Repository> { get }
    var readmeSignal: Signal<String?> { get }
}

protocol RepositoryDetailViewModelType {
    var input: RepositoryDetailViewModelInput { get }
    var output: RepositoryDetailViewModelOutput { get }
}

final class RepositoryDetailViewModel: RepositoryDetailViewModelInput, RepositoryDetailViewModelOutput {
    
    // MARK: Dependency
    
    private let repository: Repository
    private let model: RepositoryDetailModelProtocol
    
    // MARK: Properties
    
    var repositorySignal: Driver<Repository>
    var readmeSignal: Signal<String?>
    
    // MARK: Initializer
    
    init(repository: Repository,
         model: RepositoryDetailModelProtocol = RepositoryDetailModel()) {
        self.repository         = repository
        self.model              = model
        self.repositorySignal   = BehaviorRelay<Repository>(value: repository).asDriver()
        self.readmeSignal       = model.readmeRelay.asSignal()
    }
    
    // MARK: Trigger
    
    func viewDidLoad() {
        model.fetchReadme(of: repository)
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var input: RepositoryDetailViewModelInput { self }
    var output: RepositoryDetailViewModelOutput { self }
}
