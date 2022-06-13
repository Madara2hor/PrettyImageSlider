//
//  ImageSliderViewStyle.swift
//  tabBar
//
//  Created by Madara2hor on 13.06.2022.
//

import UIKit

public struct ImageSliderViewStyle {
    
    var titleTextColor: UIColor
    var titleFont: UIFont
    var descriptionTextColor: UIColor
    var descriptionFont: UIFont
    
    public init(titleTextColor: UIColor? = .white,
         titleFont: UIFont? = UIFont.systemFont(ofSize: 14, weight: .regular),
         descriptionTextColor: UIColor? = .white,
         descriptionFont: UIFont? = UIFont.systemFont(ofSize: 24, weight: .bold)
    ) {
        self.titleTextColor = titleTextColor!
        self.titleFont = titleFont!
        self.descriptionTextColor = descriptionTextColor!
        self.descriptionFont = descriptionFont!
    }
}
