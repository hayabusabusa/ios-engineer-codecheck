//
//  SearchRepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RxCocoa

class SearchRepositoriesViewController: DisposableViewController, StateViewable {

    // MARK: IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: Properties

    var stateView = StateView()

    private var viewModel: SearchRepositoriesViewModel!

    // MARK: Lifecycle

    static func instantiate() -> SearchRepositoriesViewController {
        Storyboard.SearchRepositoriesViewController.instantiate(SearchRepositoriesViewController.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
        configureStateView()
        configureViewModel()
    }
}

// MARK: - Configurations

extension SearchRepositoriesViewController {

    private func configureNavigation() {
        let searchBar = UISearchBar(frame: navigationController?.navigationBar.frame ?? .zero)
        searchBar.delegate = self
        searchBar.placeholder = "リポジトリを検索"
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
    }

    func configureStateView() {
        setupStateView()
        stateView.updateStyle(emptyTitle: "検索結果がありません。", emptyContent: "キーワードを入力して検索してください。", errorTitle: "予期しないエラーが発生しました。")
    }

    private func configureTableView() {
        tableView.alpha = 0
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = SearchRepositoriesCell.rowHeight
        tableView.register(SearchRepositoriesCell.nib, forCellReuseIdentifier: SearchRepositoriesCell.reuseIdentifier)
    }

    private func configureViewModel() {
        let viewModel = SearchRepositoriesViewModel()
        self.viewModel = viewModel

        tableView.rx.reachedBottom.asSignal()
            .emit(onNext: { [weak self] in
                self?.viewModel.input.didReachBottom()
            })
            .disposed(by: disposeBag)

        viewModel.output.repositoriesDriver
            .drive(tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchRepositoriesCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! SearchRepositoriesCell // swiftlint:disable:this force_cast
                cell.configureCell(title: element.fullName, desc: element.desc, stars: "\(element.stargazersCount)", language: element.language, avatarURL: element.owner.avatarURL)
                return cell
            }
            .disposed(by: disposeBag)
        viewModel.output.stateDriver
            .drive(onNext: { [weak self] state in
                self?.bindTableView(with: state != .none)
                self?.bindStateView(with: state)
            })
            .disposed(by: disposeBag)
        viewModel.output.pushRepositoryDetailSignal
            .emit(onNext: { [weak self] repository in
                let vc = RepositoryDetailViewController.configure(with: repository)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binding

extension SearchRepositoriesViewController {

    private func bindTableView(with isHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = isHidden ? 0 : 1
        }
    }

    private func bindStateView(with state: StateView.State) {
        stateView.setState(of: state)
    }
}

// MARK: - SearchBar Delegate

extension SearchRepositoriesViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text,
              !keyword.isEmpty else {
            return
        }

        viewModel.input.searchBarSearchButtonClicked(keyword: keyword)

        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - TableView Delegate

extension SearchRepositoriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.didSelectRow(at: indexPath)
    }
}
