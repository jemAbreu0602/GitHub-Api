//
//  RepositoriesViewController.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

import UIKit
import WebKit

class RepositoriesViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    @IBOutlet weak var repositoriesTableView: UITableView!

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true)
    }

    var userUrl: URL?
    var avatarImage: UIImage?
    var repos: [Repositories.List.Response] = []
    var selectedRepoURL: URL?
    var isLastPage: Bool = false
    var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestDetailedUser()
        requestUserRepo()
    }

    private func setupUI() {
        avatarImageView.image = avatarImage
        repositoriesTableView.register(
            .init(nibName: "RepositoryTableViewCell", bundle: nil),
            forCellReuseIdentifier: "RepositoryCell")
        repositoriesTableView.delegate = self
        repositoriesTableView.dataSource = self
    }

    private func requestDetailedUser() {
        guard let userUrl else { return }
        let request = GitHubManager.shared.getDetailedUser(userUrl)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let data,
                let userData = try? JSONDecoder().decode(Repositories.UserInfo.Response.self, from: data)
            else { return }

            DispatchQueue.main.async {
                self?.loadUserInfo(userData)
            }
        }.resume()
    }

    private func loadUserInfo(_ user: Repositories.UserInfo.Response) {
        fullNameLabel.text = user.name
        userNameLabel.text = user.login
        bioLabel.text = user.bio
        followersLabel.text = user.followers.compactFormat()
        followingLabel.text = user.following.compactFormat()
        avatarImageView.image = avatarImage
    }

    private func requestUserRepo() {
        guard let userUrl else { return }
        let request = GitHubManager.shared.getRepos(of: userUrl, page: page)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let data,
                let repos = try? JSONDecoder().decode([Repositories.List.Response].self, from: data)
            else { return }
            
            DispatchQueue.main.async {
                self?.loadReposTable(repos)
            }
        }.resume()
    }

    private func loadReposTable(_ repos: [Repositories.List.Response]) {
        let newRepos = repos.filter({ $0.fork == false })
        self.repos = self.repos + newRepos
        if repos.isEmpty {
            isLastPage = true
        } else {
            repositoriesTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebRepo",
           let vc = segue.destination as? WebRepoViewController {
            vc.repoURL = selectedRepoURL
        }
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as? RepositoryTableViewCell
        else {
            return UITableViewCell()
        }
        cell.populate(data: repos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let string = repos[indexPath.row].html_url,
            let url = URL(string: string)
        else {
            return
        }
        selectedRepoURL = url
        performSegue(withIdentifier: "showWebRepo", sender: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1 && !isLastPage {
            page += 1
            requestUserRepo()
        }
    }
}
