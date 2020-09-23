//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var openIssuesLabel: UILabel!
    
    // MARK: Properties
    
    var searchRepositoriesViewController: SearchRepositoriesViewController!
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        fetchAvatarImage()
    }
}

// MARK: - Configurations

extension RepositoryDetailViewController {
    
    private func configureLabels() {
        let repository = searchRepositoriesViewController.repositories[searchRepositoriesViewController.selectedindex]
        
        titleLabel.text         = repository["full_name"] as? String
        languageLabel.text      = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text         = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text      = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text         = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssuesLabel.text    = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
    }
}

// MARK: - Fetch avatar image

extension RepositoryDetailViewController {
    
    private func fetchAvatarImage() {
        let repository = searchRepositoriesViewController.repositories[searchRepositoriesViewController.selectedindex]
        guard let owner = repository["owner"] as? [String: Any],
            let imageURL = owner["avatar_url"] as? String else {
                return
        }
        
        URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, res, err) in
            let image = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()
    }
}
