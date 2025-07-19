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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var followersTextField: UITextField!
    @IBOutlet weak var followingTextField: UITextField!
    @IBOutlet weak var repositoriesTableView: UITableView!

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true)
    }

    lazy var repoWebView: WKWebView = {
        let webConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()

    var userUrl: URL?
    var avatarImage: UIImage?
    var repos: [Repositories.List.Response] = []
    var selectedRepoURL: URL?

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
        let labelColor = UIColor(named: "subGray") ?? .white
        let valueColor = UIColor(named: "primaryWhite") ?? .white

        userNameTextField.attributedText = "Username:  \(user.login)"
            .toAttributedLabel(value: user.login,
                               labelColor: labelColor,
                               valueColor: valueColor)
        fullNameTextField.attributedText = "Fullname:  \(user.name)"
            .toAttributedLabel(value: user.name,
                               labelColor: labelColor,
                               valueColor: valueColor)
        followersTextField.attributedText = "No. of Followers:  \(user.followers)"
            .toAttributedLabel(value: String(user.followers),
                               labelColor: labelColor,
                               valueColor: valueColor)
        followingTextField.attributedText = "Following:  \(user.following)"
            .toAttributedLabel(value: String(user.following),
                               labelColor: labelColor,
                               valueColor: valueColor)
        avatarImageView.image = avatarImage
    }

    private func requestUserRepo() {
        guard let userUrl else { return }
        let request = GitHubManager.shared.getRepos(of: userUrl)

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
        self.repos = repos.filter({ $0.fork == false })
        repositoriesTableView.reloadData()
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
}

extension RepositoriesViewController: WKNavigationDelegate, WKUIDelegate {
    
}
