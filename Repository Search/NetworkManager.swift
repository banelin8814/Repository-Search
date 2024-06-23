//
//  APIManager.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func searchRepositories(query: String, page: Int, complition: @escaping (Result<[Repository], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        guard let url = urlComponents.url else {
            complition(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        
        URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            
            guard let data = data else {
                complition(.failure(NetworkError.decodingError))
                return
            }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                complition(.success(searchResult.items))
            } catch {
                complition(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

struct SearchResult: Codable {
    let items: [Repository]
}

