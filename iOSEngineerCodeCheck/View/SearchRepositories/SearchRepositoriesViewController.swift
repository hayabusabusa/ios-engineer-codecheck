//
//  SearchRepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RxCocoa

class SearchRepositoriesViewController: DisposableViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private var viewModel: SearchRepositoriesViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> SearchRepositoriesViewController {
        return Storyboard.SearchRepositoriesViewController.instantiate(SearchRepositoriesViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
        configureViewModel()
    }
}

// MARK: - Configurations

extension SearchRepositoriesViewController {
    
    private func configureNavigation() {
        let searchBar                   = UISearchBar(frame: navigationController?.navigationBar.frame ?? .zero)
        searchBar.delegate              = self
        searchBar.placeholder           = "リポジトリを検索"
        navigationItem.titleView        = searchBar
        navigationItem.titleView?.frame = searchBar.frame
    }
    
    private func configureTableView() {
        tableView.delegate = self
    }
    
    private func configureViewModel() {
        let viewModel   = SearchRepositoriesViewModel()
        self.viewModel  = viewModel
        
        viewModel.output.repositoriesDriver
            .drive(tableView.rx.items) { tableView, row, element in
                let cell                    = tableView.dequeueReusableCell(withIdentifier: "Repository", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text        = element.fullName
                cell.detailTextLabel?.text  = element.language
                return cell
            }
            .disposed(by: disposeBag)
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
              keyword.count != 0 else {
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
    }
}
