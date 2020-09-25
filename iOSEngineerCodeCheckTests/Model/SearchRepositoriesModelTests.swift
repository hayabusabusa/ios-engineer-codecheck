//
//  SearchRepositoriesModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import iOSEngineerCodeCheck

class SearchRepositoriesModelTests: XCTestCase {
    
    func test_APIへの初回データ取得後にデータが保持されていることを確認() {
        let model               = SearchRepositoriesModel(gitHubAPISearchRepository: StubGitHubAPISearchRepository())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver([String].self)
        
        scheduler.scheduleAt(100) {
            model.repositoriesRelay
                // NOTE: 比較のために `fullName` を取り出して `String` の配列で比較
                .map { $0.map { $0.fullName } }
                .subscribe(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            model.fetchRepositories(with: "TEST")
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, []),
            .next(200, ["Stub"])
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_APIへのデータ取得時にエラーが発生した場合にエラーを流すことを確認() {
        let model               = SearchRepositoriesModel(gitHubAPISearchRepository: StubGitHubAPISearchRepository(isErrorOccurred: true))
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(StubError.self)
        
        scheduler.scheduleAt(100) {
            model.errorRelay
                // NOTE: `Error` 型のままでは比較できないので流れてくる `StubError` にキャスト
                .map { $0 as! StubError }
                .subscribe(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            model.fetchRepositories(with: "TEST")
        }
        
        scheduler.start()
        
        let expression: [Recorded<Event<StubError>>] = Recorded.events([
            .next(200, StubError())
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
