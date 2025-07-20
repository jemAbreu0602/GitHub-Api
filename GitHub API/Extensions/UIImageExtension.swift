//
//  UIImageExtension.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//

import UIKit

extension UIImageView {
    
    public func imgURL(url string: String?, placeHolder: UIImage) {
        let imageCache = GitHubManager.shared.imageCache
        self.image = placeHolder
        guard
            let string,
            let url = URL(string: string)
        else {
            return
        }

        if let cachedImg = imageCache.object(forKey: NSString(string: string)) as? UIImage {
            self.image = cachedImg
            return
        }

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
                imageCache.setObject(image, forKey: NSString(string: string))
            }
        }.resume()
    }
}
