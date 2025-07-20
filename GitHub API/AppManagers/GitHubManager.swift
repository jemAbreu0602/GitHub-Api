//
//  GitHubManager.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//
import Foundation

class GitHubManager {
    static let shared = GitHubManager()

    let imageCache = NSCache<AnyObject, AnyObject>()
    let getMethod = "GET"
    let authorization = "Authorization"
    let apiVersion = "X-GitHub-Api-Version"
    let version = "2022-11-28"
    let auth = "d5Om/pi/u8vaW0aktFFQ9ZCa3+JZg/2JsvIWXLEAvolLfNecgCtMehivMz17n6XE9aNA659KbVytTy1mr1iNwksIjU2pq6rnzkne3f6gwCSbR1c1EVRynfCDmFgHu2DK"

    func getUsers(_ since: String) -> URLRequest? {
        guard
            let url = URL(string: "https://api.github.com/users"),
            let token = try? AESManager.shared.decrypt(auth)
        else { return nil }

        var request = URLRequest(url: url.appending(queryItems: [.init(name: "since", value: since)]))
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

    func getRepos(of userUrl: URL, page: Int) -> URLRequest {
        let url = userUrl.appending(path: "repos").appending(queryItems: [.init(name: "page", value: String(page))])
        var request = URLRequest(url: url)
        request.httpMethod = getMethod
        return request
    }
}
