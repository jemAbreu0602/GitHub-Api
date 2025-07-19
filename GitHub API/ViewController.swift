//
//  ViewController.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "showUsersList", sender: nil)
    }
}
