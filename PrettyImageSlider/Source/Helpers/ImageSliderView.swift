//
//  SliderObjectView.swift
//  PrettyImageSlider
//
//  Created by Madara2hor on 21.04.2021.
//

import UIKit

open class ImageSliderView: UIImageView {
    
    // MARK: - Public properties
    
    @IBInspectable
    public var titleTextColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    
    @IBInspectable
    public var titleFontSize: CGFloat = 14 {
        didSet {
            titleLabel.font = UIFont.systemFont(
                ofSize: titleFontSize,
                weight: titleFontWeight
            )
        }
    }
    
    @IBInspectable
    public var titleFontWeight: UIFont.Weight = .regular {
        didSet {
            titleLabel.font = UIFont.systemFont(
                ofSize: titleFontSize,
                weight: titleFontWeight
            )
        }
    }
    
    @IBInspectable
    public var descriptionTextColor: UIColor = .white {
        didSet {
            descriptionLabel.textColor = descriptionTextColor
        }
    }
    
    @IBInspectable
    public var descriptionFontSize: CGFloat = 24 {
        didSet {
            descriptionLabel.font = UIFont.systemFont(
                ofSize: descriptionFontSize,
                weight: descriptionFontWeight
            )
        }
    }
    
    @IBInspectable
    public var descriptionFontWeight: UIFont.Weight = .bold {
        didSet {
            descriptionLabel.font = UIFont.systemFont(
                ofSize: descriptionFontSize,
                weight: descriptionFontWeight
            )
        }
    }
    
    public var imageTitle: String? {
        return object?.title
    }
    
    public var imageDescription: String? {
        return object?.description
    }
    
    // MARK: - Private properties
    
    fileprivate var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        
        return titleLabel
    }()
    
    fileprivate var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.adjustsFontSizeToFitWidth = true
        
        return descriptionLabel
    }()
    
    fileprivate var object: ImageSliderObject?
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
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
    
    public func bind(with object: ImageSliderObject) {
        self.object = object
        image = object.image
        
        titleLabel.text = object.title
        titleLabel.textColor = titleTextColor
        titleLabel.font = UIFont.systemFont(
            ofSize: titleFontSize,
            weight: titleFontWeight
        )
        
        descriptionLabel.text = object.description
        descriptionLabel.textColor = descriptionTextColor
        descriptionLabel.font = UIFont.systemFont(
            ofSize: descriptionFontSize,
            weight: descriptionFontWeight
        )
    }
    
    // MARK: - Private methods
    
    fileprivate func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        addInnerShadow(to: [.bottom])
    }
    
    fileprivate func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    fileprivate func setupLayout() {
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
        titleLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true
    }
}
