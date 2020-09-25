//
//  ResponseTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class ResponseTests: XCTestCase {

    func test_SearchRepositoriesResponseのデコードが正しく行えることを確認() {
        XCTContext.runActivity(named: "JSONファイルからデコードが行えること") { _ in
            let json = resource(name: .searchRepositoriesResponse, resourceType: .json)
            let response = try? JSONDecoder().decode(SearchRepositoriesResponse.self, from: json)
            XCTAssertNotNil(response, "デコードに失敗したため結果が `nil` になっています")
        }
    }
}
