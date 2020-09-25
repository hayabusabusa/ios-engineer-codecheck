//
//  Stubs.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/26.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import iOSEngineerCodeCheck

enum Stubs {
    static let repository = Repository(fullName: "Stub",
                                       owner: RepositoryOwner(avatarURL: "Stub"),
                                       stargazersCount: 1,
                                       watchersCount: 1,
                                       language: "Stub",
                                       forksCount: 1,
                                       openIssueCount: 1)
    static let searchRepositoriesResponse = SearchRepositoriesResponse(totalCount: 1,
                                                                       items: [
                                                                        Repository(fullName: "Stub",
                                                                                   owner: RepositoryOwner(avatarURL: "Stub"),
                                                                                   stargazersCount: 1,
                                                                                   watchersCount: 1,
                                                                                   language: "Stub",
                                                                                   forksCount: 1,
                                                                                   openIssueCount: 1)
                                                                       ])
}