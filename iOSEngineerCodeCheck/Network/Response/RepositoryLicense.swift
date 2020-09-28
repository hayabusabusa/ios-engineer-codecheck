//
//  RepositoryLicense.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/29.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryLicense: Decodable {
    let key: String
    let name: String
    let spdxID: String
    
    private enum CodingKeys: String, CodingKey {
        case key
        case name
        case spdxID = "spdx_id"
    }
}
