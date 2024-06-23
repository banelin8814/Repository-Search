//
//  NetworkConstants.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/23.
//

import Foundation

struct NetworkConstants {
    
    static let baseURL = "https://api.github.com"
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case githubApiVersion = "X-GitHub-Api-Version"
    }
    
    enum ContentType: String {
        case json = "application/json"
        case githubJson = "application/vnd.github+json"
    }
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case jsonDecodeFailed
        case invalidRequest
        case invalidResponse(message: String)
        case httpError(statusCode: Int, data: Data?)
        case noData
        case decodingError(Error)
    }
    
    enum APIPathConstants: String {
        case searchRepositories = "/search/repositories"
    }
}

