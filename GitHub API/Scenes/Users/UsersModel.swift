//
//  UsersModel.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

struct Users {
    enum Lists {
        struct Request {
            let page: Int
        }
        struct Response: Codable {
            let login: String
            let avatar_url: String
            let url: String
        }
    }
}
