import UIKit

open class ImageSlider: UIView {
    @IBInspectable
    public var cornerRadius: CGFloat = 10 {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    public var objectStyle: ImageSliderViewStyle = ImageSliderViewStyle() {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    public var hidePageControlOnSinglePage: Bool = true {
        didSet {
            pageControl.hideOnSinglePage = hidePageControlOnSinglePage
        }
    }
    public var isAutoScrollable: Bool = false {
        didSet {
            isUserInteracted = !isAutoScrollable
            swipeLeft.isEnabled = isAutoScrollable
            swipeRight.isEnabled = isAutoScrollable
        }
    }
    public var currentPage: Int { pageControl.page }
    public var scrollTimeInterval: TimeInterval = 3
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    private var pageControl = ChipPageControl()
    
    private var sliderItems: [ImageSliderViewObject] = []
    private var customSliderItems: [UIView] = []
    
    private var autoScrollTimer: Timer?
    private var beginAutoScroll: DispatchWorkItem?
    private var swipeLeft: UISwipeGestureRecognizer!
    private var swipeRight: UISwipeGestureRecognizer!
    
    private var isUserInteracted: Bool = true
    private var isNeedToStartScrolling: Bool = false
    private var isCustomItemsUsed: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupViews()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
        setupViews()
        setupLayout()
    }
    
    public func bind(with sliderObjects: [ImageSliderViewObject]) {
        bind(objects: sliderObjects) { updatedSliderObjects in
            sliderItems = updatedSliderObjects
            
            sliderItems.forEach { object in
                let imageSliderView = ImageSliderView(frame: .zero)
                imageSliderView.bind(with: object)
                imageSliderView.objectStyle = objectStyle
                
                stackView.addArrangedSubview(imageSliderView)
                
                imageSliderView.translatesAutoresizingMaskIntoConstraints = false
                imageSliderView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            }
        }
    }
    
    public func bind(with customViews: [UIView]) {
        bind(objects: customViews) { updatedViews in
            isCustomItemsUsed = true
            customSliderItems = updatedViews
            
            customSliderItems.forEach { view in
                stackView.addArrangedSubview(view)
                
                view.translatesAutoresizingMaskIntoConstraints = false
                view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            }
        }
    }
    
    public func startAutoScrolling() {
        if isAutoScrollable == false {
            return
        }
        
        isNeedToStartScrolling = true
        if pageControl.numberOfPages <= .one {
            return
        }
        
        isUserInteracted = false
        autoScrollTimer?.invalidate()
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: scrollTimeInterval,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
    }

    public func stopAutoScrolling() {
        isUserInteracted = true
        autoScrollTimer?.invalidate()
    }
    
    private func setup() {
        scrollView.delegate = self
        
        setupShadow()
        addSwipeGestures()
    }
    
    private func setupShadow() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: .zero, height: .one)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        containerView.addSubview(pageControl)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            /// Container view constraints
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            /// Scroll view constraints
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            /// Stack view constraints
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            /// Page control constraints
            pageControl.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            pageControl.heightAnchor.constraint(equalToConstant: 1.5),
            pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    private func addSwipeGestures() {
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
        
        swipeRight.delegate = self
        swipeLeft.delegate = self
    }
    
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) {
        beginAutoScroll?.cancel()
        stopAutoScrolling()
        
        beginAutoScroll = DispatchWorkItem { [weak self] in
            guard let self = self else {
                return
            }
            guard self.isNeedToStartScrolling else {
                return
            }
            
            self.startAutoScrolling()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: beginAutoScroll!)
    }
    
    private func changeImageSliderViewStyle() {
        stackView.arrangedSubviews.forEach { ($0 as? ImageSliderView)?.objectStyle = objectStyle }
    }
    
    private func bind<T>(objects: [T], setup: (([T]) -> Void)) {
        clear()
        
        guard let firstItem = objects.first, let lastItem = objects.last else {
            print("🔥 Objects is empty")
            return
        }
        
        let additionalItems = prepareItems(firstItem: firstItem, lastItem: lastItem)
        let updatedItems: [T] = [additionalItems.1] + objects + [additionalItems.0]
        
        pageControl.numberOfPages = updatedItems.count - .two
        setup(updatedItems)
        
        layoutIfNeeded()
        scrollView.contentOffset = CGPoint(
            x: Int(containerView.bounds.width),
            y: .zero
        )
        
        if isNeedToStartScrolling {
            startAutoScrolling()
        }
    }
    
    private func prepareItems<T>(firstItem: T, lastItem: T) -> (T, T) {
        guard let firstItemView = firstItem as? UIView, let lastItemView = lastItem as? UIView else {
            return (firstItem, lastItem)
        }
        
        do {
            let firstItem = try firstItemView.copyObject() as! T
            let lastItem = try lastItemView.copyObject() as! T
            
            return (firstItem, lastItem)
        } catch {
            fatalError("Cannot make a copy of UIView")
        }
    }
    
    private func clear() {
        sliderItems = []
        customSliderItems = []
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        scrollView.setContentOffset(.zero, animated: false)
        isCustomItemsUsed = false
    }
}

extension ImageSlider: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Vertical scrolling disable
        // when imageslider pinned to superview
        scrollView.contentOffset.y = .zero
        guard isUserInteracted else { return }
        scrollToPage(scrollView.currentPage)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard !isUserInteracted else { return }
        scrollToPage(scrollView.currentPage)
    }
    
    @objc private func autoScroll() {
        scrollView.setContentOffset(
            CGPoint(
                x: Int(scrollView.frame.width) * (pageControl.page + .two),
                y: .zero
            ),
            animated: true
        )
    }
    
    private func scrollToPage(_ page: Int) {
        let items: [Any] = isCustomItemsUsed ? customSliderItems : sliderItems
        switch page {
        case .zero:
            scrollView.setContentOffset(
                CGPoint(
                    x: Int(scrollView.frame.width) * (items.count - .two),
                    y: .zero
                ),
                animated: false
            )
            pageControl.setPage(items.count - .three)
        case items.count - .one:
            scrollView.setContentOffset(
                CGPoint(
                    x: Int(scrollView.frame.width),
                    y: .zero
                ),
                animated: false
            )
            pageControl.setPage(.zero)
        default:
            pageControl.setPage(page - .one)
        }
    }
}

extension ImageSlider: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return true
    }
}
