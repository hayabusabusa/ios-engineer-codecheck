//
//  XCTestCase+Extension.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 山田隼也 on 2020/09/25.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    enum ResourceName: String {
        case searchRepositoriesResponse = "SearchRepositoriesResponse"
    }
        
    enum ResourceType: String {
        case json
    }
    
    func resource(name: ResourceName, resourceType: ResourceType) -> Data {
        guard let path = Bundle(for: type(of: self)).url(forResource: name.rawValue, withExtension: resourceType.rawValue),
            let data = try? Data(contentsOf: path) else {
                fatalError("\(name).json wasn't found")
        }
        return data
    }
}
