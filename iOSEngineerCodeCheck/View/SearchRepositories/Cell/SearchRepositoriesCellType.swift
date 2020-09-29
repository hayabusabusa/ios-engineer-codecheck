//
//  SearchRepositoriesCellType.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/29.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

enum SearchRepositoriesCellType: Equatable {
    case item(with: Repository)
    case indicator
}
