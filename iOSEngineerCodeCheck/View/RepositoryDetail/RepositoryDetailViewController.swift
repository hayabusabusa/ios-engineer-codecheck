//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class RepositoryDetailViewController: DisposableViewController {

    // MARK: IBOutlet

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var homepageLinkButton: UIButton!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var openIssuesLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var licenseLabel: UILabel!
    @IBOutlet private weak var layoutLicenseView: UIView!
    @IBOutlet private weak var collapsibleView: UIView!
    @IBOutlet private weak var openSafariButton: UIButton!

    // MARK: Properties

    private var viewModel: RepositoryDetailViewModel!
    private lazy var initOnViewDidAppear: Void = {
        showOpenSafariButtonWithAnimation()
    }()

    // MARK: Lifecycle

    static func configure(with repository: Repository) -> RepositoryDetailViewController {
        let vc = Storyboard.RepositoryDetailViewController.instantiate(RepositoryDetailViewController.self)
        vc.viewModel = RepositoryDetailViewModel(repository: repository)
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
        homepageLinkButton.contentHorizontalAlignment = .leading
    }

    private func configureViewModel() {
        viewModel.output.repositoryDriver
            .drive(onNext: { [weak self] repository in
                self?.bindLabels(with: repository)
                self?.bindButtons(with: repository)
                self?.bindImageView(with: repository)
            })
            .disposed(by: disposeBag)
        viewModel.output.presentSafariSignal
            .emit(onNext: { [weak self] url in
                self?.presentSafari(url: url)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind ViewModel

extension RepositoryDetailViewController {

    private func bindLabels(with repository: Repository) {
        navigationItem.title = repository.fullName
        ownerNameLabel.text = repository.owner.login
        titleLabel.text = repository.name
        descriptionLabel.text = repository.desc
        languageLabel.text = repository.language
        languageLabel.superview?.isHidden = repository.language == nil
        starsLabel.text                     = "\(repository.stargazersCount)"
        watchersLabel.text                  = "\(repository.watchersCount)"
        forksLabel.text                     = "\(repository.forksCount)"
        openIssuesLabel.text                = "\(repository.openIssueCount)"
    }

    private func bindButtons(with repository: Repository) {
        homepageLinkButton.superview?.isHidden = repository.homepage == nil || (repository.homepage ?? "").isEmpty
        homepageLinkButton.setTitle(repository.homepage, for: .normal)
        homepageLinkButton.rx.tap.asSignal()
            .emit(onNext: { [weak self] in
                self?.viewModel.input.tappedLinkButton(url: repository.homepage ?? "")
            })
            .disposed(by: disposeBag)

        layoutLicenseView.isHidden = repository.license == nil
        licenseLabel.text = repository.license?.name

        openSafariButton.rx.tap.asSignal()
            .emit(onNext: { [weak self] in
                self?.viewModel.input.tappedLinkButton(url: repository.htmlURL)
            })
            .disposed(by: disposeBag)
    }

    private func bindImageView(with repository: Repository) {
        guard let avatarURL = URL(string: repository.owner.avatarURL) else {
            return
        }
        avatarImageView.kf.setImage(with: avatarURL, options: [.transition(.fade(0.3))])
    }
}

// MARK: - Animation

extension RepositoryDetailViewController {

    private func showOpenSafariButtonWithAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
            self.collapsibleView.isHidden = false
        }
    }
}

// MARK: - Transition

extension RepositoryDetailViewController {

    private func presentSafari(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}
