//
//  WebRepoViewController.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/19/25.
//

import UIKit
import WebKit

class WebRepoViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    var repoURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repoURL else { return }
        webView.load(URLRequest(url: repoURL))
    }
}
