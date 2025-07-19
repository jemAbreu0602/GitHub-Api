//
//  UIImageExtension.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

import UIKit

extension UIImageView {
    
    public func imgURL(url: String, placeHolder: UIImage) {
        if self.image == nil {
            self.image = placeHolder
        }

        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                guard
                    let data,
                    let image = UIImage(data: data)
                else { return }
                self.image = image
            }
        }.resume()
    }
}
