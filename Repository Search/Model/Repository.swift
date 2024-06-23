//
//  SearchResponse.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/22.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let description: String?
    let owner: Owner
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, owner, language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
