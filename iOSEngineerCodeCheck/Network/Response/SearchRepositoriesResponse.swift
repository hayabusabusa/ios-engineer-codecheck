//
//  SearchRepositoriesResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

struct SearchRepositoriesResponse: Decodable {
    let totalCount: Int
    let items: [Repository]

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
