import UIKit

internal extension UIScrollView {
    var currentPage: Int { Int((contentOffset.x + frame.size.width / .two) / frame.width) }
}
