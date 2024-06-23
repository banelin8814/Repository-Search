//
//  APIManager.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/22.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func searchRepositories(query: String, page: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        let parameters = SearchParameters(q: query, page: page, perPage: 30)
        
        requestData(httpMethod: .get,
                    path: .searchRepositories,
                    parameters: parameters,
                    completion: { (result: Result<SearchResult, Error>) in
            switch result {
            case .success(let searchResult):
                completion(.success(searchResult.items))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    func requestData<E: Encodable, D: Decodable>(httpMethod: NetworkConstants.HTTPMethod,
                                                 path: NetworkConstants.APIPathConstants,
                                                 parameters: E,
                                                 completion: @escaping (Result<D, Error>) -> Void) {
        let urlRequest = handleHTTPMethod(httpMethod, path, parameters)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkConstants.RequestError.invalidResponse(message: "Not an HTTP response")))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkConstants.RequestError.httpError(statusCode: response.statusCode, data: data)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkConstants.RequestError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(D.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(NetworkConstants.RequestError.jsonDecodeFailed))
            }
        }.resume()
    }
    
    private func handleHTTPMethod<E: Encodable>(_ method: NetworkConstants.HTTPMethod,
                                                _ path: NetworkConstants.APIPathConstants,
                                                _ parameters: E) -> URLRequest {
        let baseURL = NetworkConstants.baseURL
        let fullURL = baseURL + path.rawValue
        var components = URLComponents(string: fullURL)!
        
        if method == .get {
            if let dict = try? parameters.asDictionary() {
                components.queryItems = dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
        }
        
        var urlRequest = URLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        urlRequest.allHTTPHeaderFields = [
            NetworkConstants.HttpHeaderField.acceptType.rawValue:
                NetworkConstants.ContentType.githubJson.rawValue,
            NetworkConstants.HttpHeaderField.githubApiVersion.rawValue: "2022-11-28"
        ]
        urlRequest.httpMethod = method.rawValue
                
        return urlRequest
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
