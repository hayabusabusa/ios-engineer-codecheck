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
    static let repository = Repository(id: 1,
                                       name: "Stub",
                                       fullName: "Stub",
                                       desc: "Stub",
                                       owner: RepositoryOwner(login: "Stub", avatarURL: "Stub"),
                                       homepage: "Stub",
                                       htmlURL: "Stub",
                                       stargazersCount: 1,
                                       watchersCount: 1,
                                       language: "Stub",
                                       license: RepositoryLicense(key: "Stub", name: "Stub", spdxID: "Stub"),
                                       forksCount: 1,
                                       openIssueCount: 1)
    static let searchRepositoriesResponse = SearchRepositoriesResponse(totalCount: 2,
                                                                       items: [
                                                                        Repository(id: 1,
                                                                                   name: "Stub",
                                                                                   fullName: "Stub",
                                                                                   desc: "Stub",
                                                                                   owner: RepositoryOwner(login: "Stub", avatarURL: "Stub"),
                                                                                   homepage: "Stub",
                                                                                   htmlURL: "Stub",
                                                                                   stargazersCount: 1,
                                                                                   watchersCount: 1,
                                                                                   language: "Stub",
                                                                                   license: RepositoryLicense(key: "Stub", name: "Stub", spdxID: "Stub"),
                                                                                   forksCount: 1,
                                                                                   openIssueCount: 1)
                                                                       ])
}
