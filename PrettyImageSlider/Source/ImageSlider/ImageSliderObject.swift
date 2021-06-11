//
//  ImageSliderObject.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 16.04.2021.
//

import UIKit

public struct ImageSliderObject {
    // Image for slider object
    public let image: URL
    // Title for slider object
    public let title: String?
    // Description for slider object
    public let description: String?
    
    public init(
        image: URL,
        title: String? = nil,
        description: String? = nil
    ) {
        self.image = image
        self.title = title
        self.description = description
    }
}

