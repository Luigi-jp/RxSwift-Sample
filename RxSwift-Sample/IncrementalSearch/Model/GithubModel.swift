//
//  GitHubModel.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/03/13.
//

import Foundation

struct GithubResponse: Codable {
    let items: [GithubModel]?
}

struct GithubModel: Codable {
    let id: Int
    let name : String
    let fullName: String
    var urlStr: String { "https://github.com/\(fullName)" }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
    }
}
