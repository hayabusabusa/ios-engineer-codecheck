//
//  StubRepositoryDetailModel.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import RxSwift
import RxRelay
@testable import iOSEngineerCodeCheck

final class StubRepositoryDetailModel: RepositoryDetailModelProtocol {
    
    // MARK: Properties
    
    var readmeRelay = PublishRelay<String?>()
    
    private let isErrorOccured: Bool
    
    // MARK: Initializer
    
    init(isErrorOccured: Bool = false) {
        self.isErrorOccured = isErrorOccured
    }
    
    // MARK: Call API
    
    func fetchReadme(of repository: Repository) {
        isErrorOccured ? readmeRelay.accept(nil) : readmeRelay.accept("Stub")
    }
}
