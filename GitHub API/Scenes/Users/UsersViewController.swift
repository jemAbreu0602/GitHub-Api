//
//  UsersViewController.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//
import UIKit

class UsersViewController: UIViewController {
    @IBOutlet weak var userListTableView: UITableView!

    var usersData: [Users.Lists.Response] = []
    var selectedURL: URL?
    var selectedImage: UIImage?
    var lastId: Int = 0
    var isLastPage: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestUsers()
    }

    

    private func setupUI() {
        userListTableView.register(
            .init(nibName: "UserTableViewCell", bundle: nil),
            forCellReuseIdentifier: "UserCell")
        userListTableView.delegate = self
        userListTableView.dataSource = self
    }

    private func requestUsers() {
        guard let usersListRequest = GitHubManager.shared.getUsers(String(lastId)) else { return }

        URLSession.shared.dataTask(with: usersListRequest) { [weak self] data, response, error in
            guard
                let data,
                let usersData = try? JSONDecoder().decode([Users.Lists.Response].self, from: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self?.loadTable(with: usersData)
            }
        }.resume()
    }

    private func loadTable(with users: [Users.Lists.Response]) {
        if users.isEmpty {
            isLastPage = true
            return
        }
        usersData = usersData + users
        userListTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRepositories",
           let vc = segue.destination as? RepositoriesViewController {
            vc.userUrl = selectedURL
            vc.avatarImage = selectedImage
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell
        else {
            return UITableViewCell()
        }
        cell.populate(data: usersData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell,
            let userData = cell.userData
        else {
            return
        }
        selectedURL = URL(string: userData.url ?? "")
        selectedImage = cell.avatarImage.image
        performSegue(withIdentifier: "showRepositories", sender: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == usersData.count - 1 && !isLastPage {
            lastId = usersData.last?.id ?? 0
            requestUsers()
        }
    }
}
