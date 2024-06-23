//
//  FirstVM.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/23.
//

import Foundation

protocol FirstVMProtocol: AnyObject {
    var repositories: [Repository] { get }
    var onDataUpdated: (() -> Void)? { get set }
    func searchRepositories(query: String, completion: @escaping (Bool) -> Void)
    func clearRepositories()
}

class FirstVM: FirstVMProtocol {
    
    var repositories: [Repository] = []
    
    var onDataUpdated: (() -> Void)?
    
    func searchRepositories(query: String, completion: @escaping (Bool) -> Void) {

        NetworkManager.shared.searchRepositories(query: query, page: 1) { [weak self] result in
            switch result {
            case .success(let newRepositories):
                self?.repositories = newRepositories
                self?.onDataUpdated?()
                completion(true)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func clearRepositories() {
        repositories.removeAll()
        onDataUpdated?()
    }
}
