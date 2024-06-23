//
//  ViewController.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/20.
//

import UIKit

class FirstVC: UIViewController {
   
    //MARK: - Properties
    private let searchController = UISearchController()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FirstVCTableViewCell.self, forCellReuseIdentifier: "FirstVCTableViewCell")
        return tableView
    }()
    
    private var repositories: [Repository] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setNavigtion()
        setUpTableView()
        setUpSearchBar()
        searchRepositories(query: "Swift")
    }
    //MARK: - Function
    private func setNavigtion() {
        self.navigationItem.title = "Repository Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "請輸入關鍵字搜尋"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func searchRepositories(query: String) {
        NetworkManager.shared.searchRepositories(query: query, page: 1) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
    }
}
//MARK: - Extension
extension FirstVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstVCTableViewCell", for: indexPath) as! FirstVCTableViewCell
        cell.selectionStyle = .none
        cell.repository = self.repositories[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = DetailVC()
        secondVC.configUIContent(repositories[indexPath.row])
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}

extension FirstVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            
        }
        tableView.reloadData()
    }
}
