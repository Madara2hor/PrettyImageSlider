//
//  RoundedView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 16.04.2021.
//

import UIKit

fileprivate let kDefaultCornerRadius: CGFloat = 10

open class RoundShadowView: UIView {
  
    // MARK: - Public properties
    
    /// Main image slider view
    let containerView = UIView()
  
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutView()
    }

    // MARK: - Private methods
    
    fileprivate func layoutView() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
        
        
        containerView.layer.cornerRadius = kDefaultCornerRadius
        containerView.layer.masksToBounds = true

        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

