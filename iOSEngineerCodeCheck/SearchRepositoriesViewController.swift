//
//  SearchRepositoriesViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoriesViewController: UITableViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: Properties
    
    private let githubAPIURL = "https://api.github.com/search/repositories"
    private var urlSessionTask: URLSessionTask?
    
    var repositories: [[String: Any]] = []
    var selectedindex: Int!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
    }
}

// MARK: - Configurations

extension SearchRepositoriesViewController {
    
    private func configureSearchBar() {
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
}

// MARK: - SearchBar Delegate

extension SearchRepositoriesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // NOTE: SearchBar タップ時にテキストフィールドを空にする.
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlSessionTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text,
              searchKeyword.count != 0 else {
            return
        }
        
        guard let url = URL(string: githubAPIURL + "?q=" + searchKeyword) else {
            return
        }
        
        urlSessionTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any],
                      let items = jsonObject["items"] as? [[String: Any]] else {
                        return
                }
                
                self.repositories = items
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        // NOTE: `resume()` でタスクを実行し、API へリクエストを送信する.
        urlSessionTask?.resume()
    }
}

// MARK: - TableView DataSource

extension SearchRepositoriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                    = UITableViewCell()
        let repository              = repositories[indexPath.row]
        cell.tag                    = indexPath.row
        cell.textLabel?.text        = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text  = repository["language"] as? String ?? ""
        return cell
    }
}

// MARK: - TableView Delegate

extension SearchRepositoriesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // NOTE: 詳細画面で選択したリポジトリを判別するために `indexPath.row` を保持.
        selectedindex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

// MARK: - Prepare for segue

extension SearchRepositoriesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Detail",
              let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController else {
            return
        }
        repositoryDetailViewController.searchRepositoriesViewController = self
    }
}
