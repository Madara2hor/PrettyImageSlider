//
//  UIView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 17.04.2021.
//

import UIKit

extension UIView {
    
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
            frame.height / 2 :
            radius!
        
        for edge in edges {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [fromColor, toColor]
            gradientLayer.opacity = opacity

            switch edge {
            case .top:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: mainRadius)
            case .bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - mainRadius, width: viewFrame.width, height: mainRadius)
            case .left:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: mainRadius, height: viewFrame.height)
            case .right:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.frame = CGRect(x: viewFrame.width - mainRadius, y: 0.0, width: mainRadius, height: viewFrame.height)
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
