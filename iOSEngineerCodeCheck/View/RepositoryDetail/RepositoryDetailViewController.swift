//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryDetailViewController: DisposableViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var linkButton: UIButton!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var collapsibleView: UIView!
    @IBOutlet private weak var openSafariButton: Button!
    
    // MARK: Properties
    
    private var viewModel: RepositoryDetailViewModel!
    
    private lazy var initOnViewDidAppear: Void = {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.collapsibleView.isHidden = false
        }
    }()
    
    // MARK: Lifecycle
    
    static func configure(with repository: Repository) -> RepositoryDetailViewController {
        let vc          = Storyboard.RepositoryDetailViewController.instantiate(RepositoryDetailViewController.self)
        vc.viewModel    = RepositoryDetailViewModel(repository: repository)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLinkButton()
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = initOnViewDidAppear
    }
}

// MARK: - Configurations

extension RepositoryDetailViewController {
    
    private func configureLinkButton() {
        linkButton.contentHorizontalAlignment = .leading
    }
    
    private func configureViewModel() {
        viewModel.output.repositoryDriver
            .drive(onNext: { [weak self] repository in
                self?.bindLabels(with: repository)
                self?.bindButton(with: repository)
                self?.bindImageView(with: repository)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind ViewModel

extension RepositoryDetailViewController {
    
    private func bindLabels(with repository: Repository) {
        navigationItem.title                = repository.fullName
        ownerNameLabel.text                 = repository.owner.login
        titleLabel.text                     = repository.name
        descriptionLabel.text               = repository.desc
        languageLabel.text                  = repository.language
        languageLabel.superview?.isHidden   = repository.language == nil
        starsLabel.text                     = "\(repository.stargazersCount)"
        watchersLabel.text                  = "\(repository.watchersCount)"
        forksLabel.text                     = "\(repository.forksCount)"
        openIssuesLabel.text                = "\(repository.openIssueCount)"
    }
    
    private func bindButton(with repository: Repository) {
        linkButton.superview?.isHidden = repository.homepage == nil
        linkButton.setTitle(repository.homepage, for: .normal)
    }
    
    private func bindImageView(with repository: Repository) {
        guard let avatarURL = URL(string: repository.owner.avatarURL) else {
            return
        }
        avatarImageView.kf.setImage(with: avatarURL, options: [.transition(.fade(0.3))])
    }
}
