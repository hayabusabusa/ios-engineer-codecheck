//
//  GetReadmeRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Alamofire

struct GetReadmeRequest: APICustomDecodeRequest {
    typealias Response = String?

    let ownerName: String
    let repositoryName: String

    var endpoint: String {
        "https://raw.githubusercontent.com"
    }

    var path: String {
        "/\(ownerName)/\(repositoryName)/master/README.md"
    }

    var method: HTTPMethod {
        .get
    }

    func decode(from data: Data?) throws -> String? {
        guard let data = data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
