//
//  UIScrollView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 17.04.2021.
//

import UIKit

extension UIScrollView {
    
    var currentPage: Int {
        return Int((contentOffset.x + frame.size.width / 2) / frame.width)
    }
    
}
