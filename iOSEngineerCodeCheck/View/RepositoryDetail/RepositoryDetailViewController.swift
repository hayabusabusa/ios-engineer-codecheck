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
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    
    // MARK: Properties
    
    var repository: [String: Any]!
    
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
        titleLabel.text         = repository["full_name"] as? String
        languageLabel.text      = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text         = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text      = "\(repository["watchers_count"] as? Int ?? 0) watchers"
        forksLabel.text         = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssuesLabel.text    = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
    }
}

// MARK: - Fetch avatar image

extension RepositoryDetailViewController {
    
    private func fetchAvatarImage() {
        guard let owner          = repository["owner"] as? [String: Any],
              let imageURLString = owner["avatar_url"] as? String,
              let imageURL       = URL(string: imageURLString) else {
                return
        }
        
        URLSession.shared.dataTask(with: imageURL) { [weak self] (data, res, err) in
            guard let data  = data,
                  let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageView.image = image
            }
        }.resume()
    }
}
