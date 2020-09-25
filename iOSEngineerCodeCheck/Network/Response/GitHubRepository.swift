//
//  GitHubRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubRepository: Decodable {
    let fullName: String
    let owner: GitHubRepositoryOwner
    let stargazersCount: Int
    let watchersCount: Int
    let language: String
    let forksCount: Int
    let openIssueCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case fullName           = "full_name"
        case owner
        case stargazersCount    = "stargazers_count"
        case watchersCount      = "watchers_count"
        case language
        case forksCount         = "forks_count"
        case openIssueCount     = "open_issues_count"
    }
}
