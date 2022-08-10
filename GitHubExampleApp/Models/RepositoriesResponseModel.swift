//
//  RepositoriesResponseModel.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation

// MARK: - Welcome
struct RepositoriesResponseModel: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    var items: [Repository?]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct Repository: Codable {
    let name: String?
    let owner: Owner?
    let htmlURL: String?
    let itemDescription: String?
    let createdAt: String?
    let starsCount: Int?
    let language: String?
    let forks: Int?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case createdAt = "created_at"
        case starsCount = "stargazers_count"
        case language
        case forks = "forks"
        case id
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
