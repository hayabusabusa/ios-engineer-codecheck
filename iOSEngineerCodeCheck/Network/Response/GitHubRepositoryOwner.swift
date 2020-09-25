//
//  GitHubRepositoryOwner.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubRepositoryOwner: Decodable {
    let avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
