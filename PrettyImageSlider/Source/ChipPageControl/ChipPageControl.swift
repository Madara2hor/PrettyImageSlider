//
//  ShipPageControl.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 17.04.2021.
//

import UIKit

enum PageMove {
    case forward
    case backward
}

internal class ChipPageControl: UIScrollView {
    
    // MARK: - Private properties
    
    private var currentChipWidth: CGFloat = 32
    private var chipWidth: CGFloat = 8
    
    private var ambigousConstraints: [NSLayoutConstraint] = []
    private var defaultContstraints: [NSLayoutConstraint] = []
    private var pageControlConstraints: [NSLayoutConstraint] = []
    
    private let chipStackView: UIStackView = {
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
            setContentOffset(.zero, animated: false)
            page = 0
            setupPages()
        }
    }
    
    private(set) var page: Int = 0
    
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
    
    public func setPage(_ newPage: Int) {
        guard newPage != page else { return }
        guard newPage < numberOfPages else {
            fatalError("New page is out of range. \nNew page need to be less than number of pages: \(numberOfPages)")
        }
        
        if pagesIsAmbigous() {
            let currentChipStep = currentChipWidth + chipStackView.spacing
            let step = chipWidth + chipStackView.spacing
            
            let oldContentOffest = CGPoint(x: CGFloat(page) * step, y: 0)
            let newContentOffset = CGPoint(x: CGFloat(newPage) * step, y: 0)
            
            let startScrollPosition = (frame.width - currentChipStep) / 2
            let endScrollPosition = contentSize.width - (frame.width + currentChipStep) / 2
            
            if newContentOffset.x > startScrollPosition,
               newContentOffset.x < endScrollPosition {
                animateScroll(to: step, move: newPage > page ? .forward : .backward)
            } else if newContentOffset.x < startScrollPosition,
                      oldContentOffest.x > startScrollPosition {
                animateScroll(to: step, move: .backward)
            } else if newContentOffset.x > endScrollPosition,
                      oldContentOffest.x < endScrollPosition {
                animateScroll(to: step, move: .forward)
            }
        }
        changePage(on: newPage, move: newPage > page ? .forward : .backward)
        page = newPage
    }
    
    // MARK: - Private methods
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        isUserInteractionEnabled = false
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        addSubview(chipStackView)
    }
    
    private func setupLayout() {
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
    
    private func activaConstraints(isAmbigous: Bool) {
        defaultContstraints.forEach {
            $0.isActive = !isAmbigous
        }
        ambigousConstraints.forEach {
            $0.isActive = isAmbigous
        }
    }
    
    private func hideIfNeeded() {
        if numberOfPages == 1 {
            isHidden = hideOnSinglePage
        } else {
            isHidden = false
        }
    }
    
    private func pagesIsAmbigous() -> Bool {
        layoutIfNeeded()
        return frame.width < chipStackView.frame.width
    }
    
    private func changePage(on pageIndex: Int, move: PageMove) {
        guard chipStackView.arrangedSubviews.count > 1,
              pageControlConstraints.count > 1
        else { return }
        
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
            currentPageView.backgroundColor = .white
            currentPageConstraint.constant += self.currentChipWidth - self.chipWidth
            self.layoutIfNeeded()
        })
    }
    
    private func animateScroll(to step: CGFloat, move: PageMove) {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentOffset.x += move == .forward ?
                step :
                -step
        })
    }
    
    private func setupPages() {
        clearPages()
        hideIfNeeded()
        
        for page in 0..<numberOfPages {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            chipStackView.addArrangedSubview(view)
            
            if page == self.page {
                view.backgroundColor = .white
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
    
    private func clearPages() {
        chipStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        pageControlConstraints = []
    }
}
