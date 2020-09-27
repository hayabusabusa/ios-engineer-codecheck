//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryDetailViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    
    // MARK: Properties
    
    private var repository: Repository!
    
    // MARK: Lifecycle
    
    static func configure(with repository: Repository) -> RepositoryDetailViewController {
        let vc = Storyboard.RepositoryDetailViewController.instantiate(RepositoryDetailViewController.self)
        vc.repository = repository
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        configureImageView()
    }
}

// MARK: - Configurations

extension RepositoryDetailViewController {
    
    private func configureLabels() {
        titleLabel.text         = repository.fullName
        languageLabel.text      = "Written in \(repository.language ?? "")"
        starsLabel.text         = "\(repository.stargazersCount) stars"
        watchersLabel.text      = "\(repository.watchersCount) watchers"
        forksLabel.text         = "\(repository.forksCount) forks"
        openIssuesLabel.text    = "\(repository.openIssueCount) open issues"
    }
    
    private func configureImageView() {
        guard let avatarURL = URL(string: repository.owner.avatarURL) else {
            return
        }
        avatarImageView.kf.setImage(with: avatarURL, options: [.transition(.fade(0.3))])
    }
}
