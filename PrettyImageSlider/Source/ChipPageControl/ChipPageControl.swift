import UIKit

enum PageMove {
    case forward
    case backward
}

internal class ChipPageControl: UIScrollView {
    private let chipStackView = ChipStackView()
    
    private var ambigousConstraints: [NSLayoutConstraint] = []
    private var defaultContstraints: [NSLayoutConstraint] = []
    
    var hideOnSinglePage: Bool = true { didSet { hideIfNeeded() } }
    var page: Int { chipStackView.page }
    var numberOfPages: Int = .zero {
        didSet {
            setContentOffset(.zero, animated: false)
            chipStackView.numberOfPages = numberOfPages
        }
    }
    
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
        guard newPage != page, numberOfPages > .one else {
            return
        }
        guard newPage < numberOfPages else {
            fatalError("New page is out of range: \(newPage). \nNew page need to be less than number of pages: \(numberOfPages)")
        }
        
        if pagesIsAmbigous() {
            let currentChipStep = ChipStackView.Constants.currentChipWidth + chipStackView.spacing
            let step = ChipStackView.Constants.chipWidth + chipStackView.spacing
            
            let oldContentOffest = CGPoint(x: CGFloat(page) * step, y: .zero)
            let newContentOffset = CGPoint(x: CGFloat(newPage) * step, y: .zero)
            
            let startScrollPosition = (frame.width - currentChipStep) / .two
            let endScrollPosition = contentSize.width - (frame.width + currentChipStep) / .two
            
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
        
        chipStackView.changePage(from: page, to: newPage)
    }
    
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
    
    private func setupPages() {
        hideIfNeeded()
        
        activaConstraints(isAmbigous: pagesIsAmbigous())
    }
    
    private func hideIfNeeded() {
        isHidden = numberOfPages == .one ? hideOnSinglePage : false
    }
    
    private func pagesIsAmbigous() -> Bool {
        layoutIfNeeded()
        return frame.width < chipStackView.frame.width
    }
    
    private func animateScroll(to step: CGFloat, move: PageMove) {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.contentOffset.x += move == .forward ? step : -step
            }
        )
    }
}
