//
//  RepositoriesModel.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

struct Repositories {
    enum UserInfo {
        struct Response: Codable {
            let login: String
            let name: String
            let followers: Int
            let following: Int
            let bio: String?
        }
    }
    enum List {
        struct Response: Codable {
            let name: String?
            let language: String?
            let stargazers_count: Int?
            let description: String?
            let fork: Bool?
            let html_url: String?
        }
        struct Request {
            let page: Int
        }
    }
}
