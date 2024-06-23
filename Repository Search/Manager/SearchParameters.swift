//
//  SearchParameters.swift
//  Repository Search
//
//  Created by 林佑淳 on 2024/6/23.
//

import Foundation

struct SearchParameters: Codable {
    let q: String
    let page: Int
    let perPage: Int
    
    enum CodingKeys: String, CodingKey {
        case q
        case page
        case perPage = "per_page"
    }
}
