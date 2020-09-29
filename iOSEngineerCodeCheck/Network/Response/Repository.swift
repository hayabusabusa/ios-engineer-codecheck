//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repository: Decodable, Equatable {
    let id: Int
    let name: String
    let fullName: String
    let desc: String?
    let owner: RepositoryOwner
    let homepage: String?
    let htmlURL: String
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let license: RepositoryLicense?
    let forksCount: Int
    let openIssueCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName           = "full_name"
        case desc               = "description"
        case owner
        case homepage
        case htmlURL            = "html_url"
        case stargazersCount    = "stargazers_count"
        case watchersCount      = "watchers_count"
        case language
        case license
        case forksCount         = "forks_count"
        case openIssueCount     = "open_issues_count"
    }

    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
}
