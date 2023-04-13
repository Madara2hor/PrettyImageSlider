import UIKit

class ChipStackView: UIStackView {
    enum Constants {
        static let currentChipWidth: CGFloat = 32
        static let chipWidth: CGFloat = 8
    }
    
    private var pageControlConstraints: [NSLayoutConstraint] = []
    
    var page: Int = .zero
    var numberOfPages: Int = .zero { didSet { setupPages() } }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStack()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStack()
    }
    
    func changePage(from oldPage: Int, to newPage: Int) {
        guard
            arrangedSubviews.count > .one,
            pageControlConstraints.count > .one
        else {
            return
        }
        
        let newPageView = arrangedSubviews[newPage]
        let newPageConstraint = pageControlConstraints[newPage]
        let oldPageView = arrangedSubviews[oldPage]
        let oldPageConstraint = pageControlConstraints[oldPage]
        
        UIView.animate(
            withDuration: 0.5,
            animations: {
                oldPageView.backgroundColor = .lightGray
                oldPageConstraint.constant -= Constants.currentChipWidth - Constants.chipWidth
                newPageView.backgroundColor = .white
                newPageConstraint.constant += Constants.currentChipWidth - Constants.chipWidth
                self.layoutIfNeeded()
            }
        )
        
        page = newPage
    }
    
    private func setupStack() {
        spacing = 4
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
    }
    
    private func setupPages() {
        clearPages()
        
        for page in .zero..<numberOfPages {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            addArrangedSubview(view)
            
            if page == self.page {
                view.backgroundColor = .white
                let width = view.widthAnchor.constraint(equalToConstant: ChipStackView.Constants.currentChipWidth)
                width.isActive = true
                pageControlConstraints.append(width)
            } else {
                view.backgroundColor = .lightGray
                let width = view.widthAnchor.constraint(equalToConstant: ChipStackView.Constants.chipWidth)
                width.isActive = true
                pageControlConstraints.append(width)
            }
        }
    }
    
    private func clearPages() {
        arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        pageControlConstraints = []
    }
}
