//
//  ChipStackView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 19.04.2021.
//

import UIKit

class ChipStackView: UIStackView {
    
    private var currentChipWidth: CGFloat = 32
    private var chipWidth: CGFloat = 8
    
    var currentPage: Int = 0 {
        didSet {
            setupPages()
        }
    }
    
    var numberOfPages: Int = 0 {
        didSet {
            setupPages()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStack()
    }
    
    private func setupPages() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for page in 0..<numberOfPages {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            
            addArrangedSubview(view)
            
            if page == currentPage {
                view.widthAnchor.constraint(equalToConstant: currentChipWidth).isActive = true
            } else {
                view.backgroundColor = .lightGray
                view.widthAnchor.constraint(equalToConstant: chipWidth).isActive = true
            }
        }
    }
    
    private func setupStack() {
        spacing = 4
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
    }
}
