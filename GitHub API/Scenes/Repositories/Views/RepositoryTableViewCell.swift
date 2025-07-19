//
//  RepositoryTableViewCell.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/19/25.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!

    func populate(data: Repositories.List.Response) {
        nameLabel.text = data.name
        descLabel.text = data.description
        languageLabel.text = data.language
        starLabel.text = String(data.stargazers_count ?? 0)
    }
}
