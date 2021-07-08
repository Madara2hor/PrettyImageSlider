//
//  ImageSlider.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 16.04.2021.
//


import UIKit

open class ImageSlider: UIView {
    
    // MARK: - Public properties
    
    @IBInspectable
    public var cornerRadius: CGFloat = 10 {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    public var titleTextColor: UIColor = .white {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    @IBInspectable
    public var titleFont: UIFont = UIFont.systemFont(
        ofSize: 14,
        weight: .regular
    ) {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    @IBInspectable
    public var descriptionTextColor: UIColor = .white {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    public var descriptionFont: UIFont = UIFont.systemFont(
        ofSize: 24,
        weight: .bold
    ) {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    public var hidePageControlOnSinglePage: Bool = true {
        didSet {
            pageControl.hideOnSinglePage = hidePageControlOnSinglePage
        }
    }
    
    public var currentPage: Int {
        return scrollView.currentPage
    }
    
    public var isAutoScrollable: Bool = true
    
    public var scrollTimeInterval: TimeInterval = 3
    
    // MARK: - Private properties
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private var pageControl = ChipPageControl()
    
    private var sliderItems: [ImageSliderObject] = []
    
    private var autoScrollTimer : Timer?
    
    private var autoScrollDirection: PageMove = .forward
    
    private var beginAutoScroll: DispatchWorkItem?
    
    private var isUserInteracted: Bool = false
    
    private var isNeedToStartScrolling: Bool = false
    
    // MARK: - Init
    
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
    
    // MARK: - Public methods
    
    public func bind(with sliderObjects: [ImageSliderObject]) {
        clear()
        
        sliderItems = sliderObjects
        pageControl.numberOfPages = sliderObjects.count
        
        sliderObjects.forEach { object in
            let imageSliderView = ImageSliderView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: frame.width,
                    height: frame.height
                )
            )
            imageSliderView.bind(with: object)
            setStyle(for: imageSliderView)
            stackView.addArrangedSubview(imageSliderView)
            setupImageSliderViewConstraints(imageSliderView)
        }
        
        if isNeedToStartScrolling {
            startAutoScrolling()
        }
    }
    
    public func startAutoScrolling() {
        guard isAutoScrollable else { return }
        guard pageControl.numberOfPages > 1 else {
            isNeedToStartScrolling = true
            return
        }
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
        isNeedToStartScrolling = false
        autoScrollTimer?.invalidate()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
        
        scrollView.delegate = self
        addSwipeGestures()
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        containerView.addSubview(pageControl)
    }
    
    private func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
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
        ]
        
        constraints.forEach {
            $0.isActive = true
        }
        
    }
    
    /// Seems like shit, but it's work
    private func setupImageSliderViewConstraints(_ view: ImageSliderView) {
        let heightConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .height,
            relatedBy: .equal,
            toItem: view,
            attribute: .height,
            multiplier: 1,
            constant: 0
        )
        let widthConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 1,
            constant: 0
        )
        containerView.addConstraint(heightConstraint)
        containerView.addConstraint(widthConstraint)
    }
    
    private func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleGesture)
        )
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleGesture)
        )
        swipeRight.direction = .right
        
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
        
        swipeRight.delegate = self
        swipeLeft.delegate = self
    }
    
    @objc private func handleGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            autoScrollDirection = .forward
        } else if gesture.direction == .right {
            autoScrollDirection = .backward
        }
        
        beginAutoScroll?.cancel()
        
        isUserInteracted = true
        stopAutoScrolling()
        
        beginAutoScroll = DispatchWorkItem { [self] in
            guard isAutoScrollable else { return }
            isUserInteracted = false
            startAutoScrolling()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: beginAutoScroll!)
    }
    
    private func changeImageSliderViewStyle() {
        stackView.arrangedSubviews.forEach {
            if let imageSliderView = $0 as? ImageSliderView {
                setStyle(for: imageSliderView)
            }
        }
    }
    
    private func setStyle(for imageSliderView: ImageSliderView) {
        imageSliderView.titleTextColor = titleTextColor
        imageSliderView.titleFont = titleFont
        imageSliderView.descriptionTextColor = descriptionTextColor
        imageSliderView.descriptionFont = descriptionFont
    }
    
    private func clear() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        scrollView.setContentOffset(.zero, animated: false)
    }
    
}

extension ImageSlider: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Vertical scrolling disable
        // when imageslider pinned to superview
        scrollView.contentOffset.y = 0
        guard isUserInteracted else { return }
        
        if pageControl.page != scrollView.currentPage {
            pageControl.setPage(scrollView.currentPage)
        }
    }
    
    @objc private func autoScroll() {
        if pageControl.page == 0 {
            autoScrollDirection = .forward
        } else if pageControl.page == pageControl.numberOfPages - 1 {
            autoScrollDirection = .backward
        }
        let newPage = autoScrollDirection == .forward ?
            pageControl.page + 1:
            pageControl.page - 1
        
        scrollView.setContentOffset(
            CGPoint(
                x: Int(scrollView.frame.width) * newPage,
                y: 0
            ),
            animated: true
        )
        pageControl.setPage(newPage)
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
