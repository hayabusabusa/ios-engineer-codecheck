//
//  RepositoryDetailModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import iOSEngineerCodeCheck

class RepositoryDetailModelTests: XCTestCase {

    func test_READMEのテキスト取得後にテキストが保持されていることを確認() {
        let model               = RepositoryDetailModel(gitHubAPIReadmeRepository: StubGitHubAPIReadmeRepository())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(String?.self)
        
        scheduler.scheduleAt(100) {
            model.readmeRelay
                .subscribe(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            model.fetchReadme(of: Stubs.repository)
        }
        
        scheduler.start()
        
        let expression:  [Recorded<Event<String?>>] = Recorded.events([
            .next(200, "Stub")
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_READMEのテキスト取得時にエラーが発生した場合にnilを流すことを確認() {
        let model               = RepositoryDetailModel(gitHubAPIReadmeRepository: StubGitHubAPIReadmeRepository(isErrorOccurred: true))
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(String?.self)
        
        scheduler.scheduleAt(100) {
            model.readmeRelay
                .subscribe(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            model.fetchReadme(of: Stubs.repository)
        }
        
        scheduler.start()
        
        let expression:  [Recorded<Event<String?>>] = Recorded.events([
            .next(200, nil)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
