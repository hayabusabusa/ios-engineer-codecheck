//
//  Storyboard.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/26.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

// NOTE: Storyboardのファイル名を使用するため、以下のルールを無効.
// swiftlint:disable identifier_name
enum Storyboard: String {
    case RepositoryDetailViewController
    case SearchRepositoriesViewController

    func instantiate<VC: UIViewController>(_: VC.Type, inBundle: Bundle? = nil) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: inBundle).instantiateInitialViewController() as? VC else {
            fatalError("Couldn't instantiate \(self.rawValue)")
        }
        return vc
    }
}
