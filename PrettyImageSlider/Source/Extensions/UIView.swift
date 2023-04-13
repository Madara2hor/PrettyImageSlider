import UIKit

internal extension UIView {
    func addInnerShadow(
        to edges: [UIRectEdge],
        radius: CGFloat? = nil,
        opacity: Float = 0.6,
        color: CGColor = UIColor.black.cgColor
    ) {
        let fromColor = color
        let toColor = UIColor.clear.cgColor
        let viewFrame = frame
        let mainRadius = radius == nil ?
            frame.height / 1.7 :
            radius!
        
        for edge in edges {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [fromColor, toColor]
            gradientLayer.opacity = opacity

            switch edge {
            case .top:
                gradientLayer.startPoint = CGPoint(x: .half, y: .zero)
                gradientLayer.endPoint = CGPoint(x: .half, y: .one)
                gradientLayer.frame = CGRect(
                    x: .zero,
                    y: .zero,
                    width: viewFrame.width,
                    height: mainRadius
                )
            case .bottom:
                gradientLayer.startPoint = CGPoint(x: .half, y: .one)
                gradientLayer.endPoint = CGPoint(x: .half, y: .zero)
                gradientLayer.frame = CGRect(
                    x: .zero,
                    y: viewFrame.height - mainRadius,
                    width: viewFrame.width,
                    height: mainRadius
                )
            case .left:
                gradientLayer.startPoint = CGPoint(x: .zero, y: .half)
                gradientLayer.endPoint = CGPoint(x: .one, y: .half)
                gradientLayer.frame = CGRect(
                    x: .zero,
                    y: .zero,
                    width: mainRadius,
                    height: viewFrame.height
                )
            case .right:
                gradientLayer.startPoint = CGPoint(x: .one, y: .half)
                gradientLayer.endPoint = CGPoint(x: .zero, y: .half)
                gradientLayer.frame = CGRect(
                    x: viewFrame.width - mainRadius,
                    y: .zero,
                    width: mainRadius,
                    height: viewFrame.height
                )
            default:
                break
            }
            layer.addSublayer(gradientLayer)
        }
    }

    func removeAllShadows() {
        if let sublayers = layer.sublayers {
            sublayers.forEach {
                $0.removeFromSuperlayer()
            }
        }
    }
}
