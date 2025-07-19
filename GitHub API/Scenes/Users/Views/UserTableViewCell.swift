//
//  UserTableViewCell.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    var userData: Users.Lists.Response?

    func populate(data: Users.Lists.Response) {
        let placeHolderImage = UIImage()
        avatarImage.imgURL(url: data.avatar_url, placeHolder: placeHolderImage)
        userNameLabel.text = data.login
        userData = data
    }
}
