//
//  RepositoryOwner.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryOwner: Decodable {
    let login: String
    let avatarURL: String

    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
