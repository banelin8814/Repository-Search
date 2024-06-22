//
//  ViewController.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/20.
//

import UIKit

class FirstVC: UIViewController {
   
    //MARK: - Properties
    let searchController = UISearchController()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FirstVCTableViewCell.self, forCellReuseIdentifier: "FirstVCTableViewCell")
        return tableView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setNavigtion()
        setUpTableView()
        setUpSearchBar()
    }
    //MARK: - Function
    func setNavigtion() {
        self.navigationItem.title = "Repository Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "請輸入關鍵字搜尋"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
//MARK: - Extension
extension FirstVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstVCTableViewCell", for: indexPath)
        cell.textLabel?.text = "123"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = DetailVC()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

extension FirstVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            
        }
        tableView.reloadData()
    }
}
