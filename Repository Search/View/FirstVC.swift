//
//  ViewController.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/20.
//

import UIKit

class FirstVC: UIViewController {
    
    //MARK: - Properties
    
    private var firstVM: FirstVMProtocol!
    
    private var refreshControl: UIRefreshControl!
    
    private let searchController = UISearchController()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FirstVCTableViewCell.self, forCellReuseIdentifier: "FirstVCTableViewCell")
        return tableView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setNavigtion()
        setUpTableView()
        setUpRefreshControl()
        setUpSearchBar()
        firstVM = FirstVM()
        firstVM.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()


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
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .gray
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    private func setUpSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "請輸入關鍵字搜尋"
        searchController.searchBar.delegate = self
        searchController.searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()


        definesPresentationContext = true
        
    }
    
    private func clearSearchResults() {
        firstVM.clearRepositories()
        tableView.reloadData()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Oops!", message: "The data couldn't be read because it is missing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func loadData() {
        refreshControl.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.firstVM.searchRepositories(query: self?.searchController.searchBar.text ?? "") { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.tableView.reloadData()
                    } else {
                        self?.showAlert()
                    }
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
}
//MARK: - Extension
extension FirstVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firstVM.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstVCTableViewCell", for: indexPath) as! FirstVCTableViewCell
        cell.selectionStyle = .none
        cell.repository = firstVM.repositories[indexPath.row]
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = DetailVC()
        secondVC.configUIContent(firstVM.repositories[indexPath.row])
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}

extension FirstVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            firstVM.searchRepositories(query: searchText, completion: { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.tableView.reloadData()
                    } else {
                        self?.showAlert()
                    }
                }
            })
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            clearSearchResults()
        }
    }
}

extension FirstVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            navigationController?.navigationBar.barTintColor = UIColor.black
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}
