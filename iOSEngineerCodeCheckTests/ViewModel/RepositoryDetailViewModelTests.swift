//
//  RepositoryDetailViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import iOSEngineerCodeCheck

class RepositoryDetailViewModelTests: XCTestCase {

    func test_ViewModel初期化後にrepositoryDriverを購読するとリポジトリの情報が流れてきることを確認() {
        let viewModel           = RepositoryDetailViewModel(repository: Stubs.repository)
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.repositoryDriver
                // NOTE: 比較のために `fullName` を取り出して `String` で比較
                .map { $0.fullName }
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, "Stub")
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
