//
//  SearchRepositoriesRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Alamofire

struct SearchRepositoriesRequest: APIRequest {
    typealias Response = SearchRepositoriesResponse

    let keyword: String

    var path: String {
        "/search/repositories"
    }

    var method: HTTPMethod {
        .get
    }

    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }

    var parameters: Parameters? {
        [
            "q": keyword
        ]
    }
}
