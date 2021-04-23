//
//  ImageSlider.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 16.04.2021.
//


import UIKit

open class ImageSlider: RoundShadowView {
    
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
    public var titleFontSize: CGFloat = 14 {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    @IBInspectable
    public var titleFontWeight: UIFont.Weight = .regular {
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
    
    @IBInspectable
    public var descriptionFontSize: CGFloat = 24 {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    @IBInspectable
    public var descriptionFontWeight: UIFont.Weight = .bold {
        didSet {
            changeImageSliderViewStyle()
        }
    }
    
    @IBInspectable
    public var hidePageControlOnSinglePage: Bool = true {
        didSet {
            pageControl.hideOnSinglePage = hidePageControlOnSinglePage
        }
    }
    
    // MARK: - Private properties
    
    fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    fileprivate var pageControl = ChipPageControl()
    
    fileprivate var sliderItems: [ImageSliderObject] = []
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.delegate = self
        setupViews()
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        scrollView.delegate = self
        setupViews()
        setupLayout()
    }
    
    // MARK: - Public methods
    
    public func bind(with sliderObjects: [ImageSliderObject]) {
        sliderItems = sliderObjects
        
        clear()
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
            stackView.addArrangedSubview(imageSliderView)
        }
    }
    
    public func append(_ sliderObjects: [ImageSliderObject]) {
        sliderItems += sliderObjects
        pageControl.numberOfPages = sliderItems.count
        
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
            stackView.addArrangedSubview(imageSliderView)
        }
    }
    
    public func remove(at index: Int) {
        guard !sliderItems.isEmpty, index >= 0, index < sliderItems.count else {
            preconditionFailure("Index out of range.")
        }
        sliderItems.remove(at: index)
        
        let viewOnRemove = stackView.arrangedSubviews[index]
        stackView.removeArrangedSubview(viewOnRemove)
        pageControl.numberOfPages = sliderItems.count
        if pageControl.page == sliderItems.count, pageControl.page != 0 {
            pageControl.page -= 1
        }
    }
    
    // MARK: - Private methods
    
    fileprivate func setupViews() {
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        containerView.addSubview(pageControl)
    }
    
    fileprivate func setupLayout() {
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        pageControl.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        containerView.layoutIfNeeded()
    }
    
    fileprivate func changeImageSliderViewStyle() {
        stackView.arrangedSubviews.forEach {
            if let imageSliderView = $0 as? ImageSliderView {
                imageSliderView.titleTextColor = titleTextColor
                imageSliderView.titleFontWeight = titleFontWeight
                imageSliderView.titleFontSize = titleFontSize
                imageSliderView.descriptionTextColor = descriptionTextColor
                imageSliderView.descriptionFontWeight = descriptionFontWeight
                imageSliderView.descriptionFontSize = descriptionFontSize
            }
        }
    }
    
    fileprivate func clear() {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}

extension ImageSlider: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pageControl.page != scrollView.currentPage {
            pageControl.page = scrollView.currentPage
        }
    }
    
}
