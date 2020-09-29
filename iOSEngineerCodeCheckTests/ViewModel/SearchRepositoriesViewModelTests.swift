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
    
    func test_検索実行後に表示用のデータが正しく流れることを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver([SearchRepositoriesCellType].self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.dataSourceDriver
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.start()
        
        let expression: [Recorded<Event<[SearchRepositoriesCellType]>>] = Recorded.events([
            .next(100, []),
            .next(200, [.item(with: Stubs.repository), .indicator])
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_検索実行後表示されているリスト選択時に選択したデータが正しく流れることを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.pushRepositoryDetailSignal
                // NOTE: 比較のために `fullName` を取り出して `String` で比較
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
    
    func test_次のページ読み込みが発生した場合の正しくデータが流れてくることを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver([SearchRepositoriesCellType].self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.dataSourceDriver
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.scheduleAt(300) {
            viewModel.input.didReachBottom()
        }
        
        scheduler.start()
        
        let expression: [Recorded<Event<[SearchRepositoriesCellType]>>] = Recorded.events([
            .next(100, []),
            .next(200, [.item(with: Stubs.repository), .indicator]),
            .next(300, [.item(with: Stubs.repository), .item(with: Stubs.repository)])
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_ページネーション実行後再度検索を行った場合にデータがリフレッシュされていることを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver([SearchRepositoriesCellType].self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.dataSourceDriver
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.scheduleAt(300) {
            viewModel.input.didReachBottom()
        }
        
        scheduler.scheduleAt(400) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.start()
        
        let expression: [Recorded<Event<[SearchRepositoriesCellType]>>] = Recorded.events([
            .next(100, []),
            .next(200, [.item(with: Stubs.repository), .indicator]),
            .next(300, [.item(with: Stubs.repository), .item(with: Stubs.repository)]),
            .next(400, [.item(with: Stubs.repository), .indicator])
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_検索実行から完了までのStateの値が正しいことを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel())
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(StateView.State.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.stateDriver
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }

        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, StateView.State.empty),
            .next(200, StateView.State.loading),
            .next(200, StateView.State.none)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_検索結果が何もなかった場合のStateの値が正しいことを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel(isRepositoriesEmpty: true))
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(StateView.State.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.stateDriver
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }

        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, StateView.State.empty),
            .next(200, StateView.State.loading),
            .next(200, StateView.State.none),
            .next(200, StateView.State.empty)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_検索実行時にエラーが発生した場合のStateの値が正しいことを確認() {
        let viewModel           = SearchRepositoriesViewModel(model: StubSearchRepositoriesModel(isErrorOccured: true))
        let disposeBag          = DisposeBag()
        let scheduler           = TestScheduler(initialClock: 0)
        let testableObserver    = scheduler.createObserver(StateView.State.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.stateDriver
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }

        scheduler.scheduleAt(200) {
            viewModel.input.searchBarSearchButtonClicked(keyword: "TEST")
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, StateView.State.empty),
            .next(200, StateView.State.loading),
            .next(200, StateView.State.none),
            .next(200, StateView.State.error)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
