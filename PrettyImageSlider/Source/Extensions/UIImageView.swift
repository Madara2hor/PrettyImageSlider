//
//  UIImageView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 30.04.2021.
//

import UIKit

internal extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
