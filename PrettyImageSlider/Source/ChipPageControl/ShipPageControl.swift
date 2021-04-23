//
//  ShipPageControl.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 17.04.2021.
//

import UIKit

fileprivate enum PageMove {
    case forward
    case backward
}

class ChipPageControl: UIScrollView {
    
    // MARK: - Private properties
    
    fileprivate var currentChipWidth: CGFloat = 32
    fileprivate var chipWidth: CGFloat = 8
    
    fileprivate var ambigousConstraints: [NSLayoutConstraint] = []
    fileprivate var defaultContstraints: [NSLayoutConstraint] = []
    fileprivate var pageControlConstraints: [NSLayoutConstraint] = []
    
    fileprivate let chipStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - Public properties
    
    var hideOnSinglePage: Bool = true {
        didSet {
            hideIfNeeded()
        }
    }
    
    var numberOfPages: Int = 0 {
        didSet {
            setupPages()
        }
    }
    
    var page: Int = 0 {
        willSet {
            if pagesIsAmbigous() {
                /// I finally did it! Don't touch this shit!
                let currentChipStep = currentChipWidth + chipStackView.spacing
                let step = chipWidth + chipStackView.spacing
                let newContentOffset = CGPoint(x: CGFloat(newValue) * step, y: 0)
                /// First half of screen from scroll contentSize width
                let firstHalfOfScreen = (frame.width - currentChipStep) / 2
                /// Last half of screen from scroll contentSize width
                let lastHalfOfScreen = contentSize.width - (frame.width + currentChipStep) / 2
                
                if newContentOffset.x > firstHalfOfScreen.rounded(.down),
                   newContentOffset.x < lastHalfOfScreen.rounded(.down) {
                    animateScroll(to: step, move: newValue > page ? .forward : .backward)
                } else if newContentOffset.x <= firstHalfOfScreen.rounded(.down),
                          newValue < self.page,
                          CGFloat(page) * step > firstHalfOfScreen.rounded(.down) {
                    animateScroll(to: step, move: .backward)
                } else if newContentOffset.x >= lastHalfOfScreen.rounded(.down),
                          newValue > self.page,
                          CGFloat(page) * step < lastHalfOfScreen.rounded(.down) {
                    animateScroll(to: step, move: .forward)
                }
            }
            changePage(on: newValue, move: newValue > page ? .forward : .backward)
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    // MARK: - Private methods
    
    fileprivate func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        isUserInteractionEnabled = false
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        addSubview(chipStackView)
    }
    
    fileprivate func setupLayout() {
        defaultContstraints = [
            chipStackView.centerXAnchor.constraint(lessThanOrEqualTo: centerXAnchor),
            chipStackView.topAnchor.constraint(equalTo: topAnchor),
            chipStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chipStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        ambigousConstraints = [
            chipStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chipStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chipStackView.topAnchor.constraint(equalTo: topAnchor),
            chipStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chipStackView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        activaConstraints(isAmbigous: false)
    }
    
    fileprivate func activaConstraints(isAmbigous: Bool) {
        defaultContstraints.forEach {
            $0.isActive = !isAmbigous
        }
        ambigousConstraints.forEach {
            $0.isActive = isAmbigous
        }
    }
    
    fileprivate func hideIfNeeded() {
        if numberOfPages == 1 {
            isHidden = hideOnSinglePage
        }
    }
    
    fileprivate func pagesIsAmbigous() -> Bool {
        layoutIfNeeded()
        return frame.size.width < chipStackView.frame.width
    }
    
    fileprivate func changePage(on pageIndex: Int, move: PageMove) {
        let currentPageView = chipStackView.arrangedSubviews[pageIndex]
        let currentPageConstraint = pageControlConstraints[pageIndex]

        let oldPageView = move == .forward ?
            chipStackView.arrangedSubviews[pageIndex - 1] :
            chipStackView.arrangedSubviews[pageIndex + 1]
        let oldPageConstraint = move == .forward ?
            pageControlConstraints[pageIndex - 1] :
            pageControlConstraints[pageIndex + 1]
        UIView.animate(withDuration: 0.5, animations: {
            oldPageView.backgroundColor = .lightGray
            oldPageConstraint.constant -= self.currentChipWidth - self.chipWidth
            self.chipStackView.layoutIfNeeded()
        })
        

        UIView.animate(withDuration: 0.5, animations: {
            currentPageView.backgroundColor = .white
            currentPageConstraint.constant += self.currentChipWidth - self.chipWidth
            self.chipStackView.layoutIfNeeded()
        })
    }
    
    fileprivate func animateScroll(to step: CGFloat, move: PageMove) {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentOffset.x += move == .forward ?
                step :
                -step
            self.layoutIfNeeded()
        })
    }
    
    fileprivate func setupPages() {
        clearPages()
        hideIfNeeded()
        
        guard !isHidden else { return }
        
        for page in 0..<numberOfPages {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            
            chipStackView.addArrangedSubview(view)
            
            if page == self.page {
                let width = view.widthAnchor.constraint(equalToConstant: currentChipWidth)
                width.isActive = true
                pageControlConstraints.append(width)
            } else {
                view.backgroundColor = .lightGray
                let width = view.widthAnchor.constraint(equalToConstant: chipWidth)
                width.isActive = true
                pageControlConstraints.append(width)
            }
        }
        
        activaConstraints(isAmbigous: pagesIsAmbigous())
    }
    
    fileprivate func clearPages() {
        chipStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
