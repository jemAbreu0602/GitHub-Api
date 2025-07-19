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
