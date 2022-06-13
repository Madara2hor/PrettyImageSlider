//
//  UIScrollView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 17.04.2021.
//

import UIKit

internal extension UIScrollView {
    
    var currentPage: Int { Int((contentOffset.x + frame.size.width / 2) / frame.width) }
}
