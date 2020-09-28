//
//  APICustomDecodeRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Alamofire

protocol APICustomDecodeRequest {
    associatedtype Response: Decodable
    
    var endpoint: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var parameters: Alamofire.Parameters? { get }
    var headers: Alamofire.HTTPHeaders? { get }
    var sampleData: Response? { get }
    
    func decode(from data: Data?) throws -> Response
}

extension APICustomDecodeRequest {
    
    var endpoint: String {
        return "https://api.github.com"
    }
    
    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding.default
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var sampleData: Response? {
        return nil
    }
}
