//
//  GitHubManager.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//
import Foundation

class GitHubManager {
    static let shared = GitHubManager()

    let getMethod = "GET"
    let authorization = "Authorization"
    let apiVersion = "X-GitHub-Api-Version"
    let version = "2022-11-28"
    let token = "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"

    func getUsers() -> URLRequest? {
        guard
            let url = URL(string: "https://api.github.com/users")
        else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = getMethod
        request.addValue(token.bearer, forHTTPHeaderField: authorization)
        request.addValue(version, forHTTPHeaderField: apiVersion)
        return request
    }

    func getDetailedUser(_ userUrl: URL) -> URLRequest {
        var request = URLRequest(url: userUrl)
        request.httpMethod = getMethod
        return request
    }

    func getRepos(of userUrl: URL) -> URLRequest {
        let url = userUrl.appending(path: "repos")
        var request = URLRequest(url: url)
        request.httpMethod = getMethod
        return request
    }
}
