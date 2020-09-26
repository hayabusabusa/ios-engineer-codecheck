//
//  SearchRepositoriesViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/26.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import iOSEngineerCodeCheck

class SearchRepositoriesViewModelTests: XCTestCase {
    
    func test_検索実行後にAPIから取得したデータが正しく流れることを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver([String].self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.repositoriesDriver
                // NOTE: 比較のために `fullName` を取り出して `String` の配列で比較
                .map { $0.map { $0.fullName } }
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, []),
            .next(200, ["Stub"])
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_検索実行後表示されているリスト選択時に選択したデータが正しく流れてくることを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.pushRepositoryDetailSignal
                // NOTE: 比較のために `fullName` を取り出して `String` の配列で比較
                .map { $0.fullName }
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.scheduleAt(300) {
            viewModel.input.didSelectRow(at: IndexPath(row: 0, section: 0))
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(300, "Stub")
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
