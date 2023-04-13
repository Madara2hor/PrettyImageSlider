import UIKit

public struct ImageSliderViewObject {
    public let image: UIImage
    public let title: String?
    public let description: String?
    
    public init(
        image: UIImage,
        title: String? = nil,
        description: String? = nil
    ) {
        self.image = image
        self.title = title
        self.description = description
    }
}

