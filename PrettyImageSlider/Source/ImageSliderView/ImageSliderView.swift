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
    
    public var titleFont: UIFont = UIFont.systemFont(
        ofSize: 14,
        weight: .regular
    ) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    @IBInspectable
    public var descriptionTextColor: UIColor = .white {
        didSet {
            descriptionLabel.textColor = descriptionTextColor
        }
    }
    
    public var descriptionFont: UIFont = UIFont.systemFont(
        ofSize: 24,
        weight: .bold
    ) {
        didSet {
            descriptionLabel.font = descriptionFont
        }
    }
    
    public var imageTitle: String? {
        return object?.title
    }
    
    public var imageDescription: String? {
        return object?.description
    }
    
    // MARK: - Private properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    private var object: ImageSliderObject?
    
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
    
    public func bind(with object: ImageSliderObject) {
        self.object = object
        load(url: object.image)
        
        titleLabel.text = object.title
        titleLabel.textColor = titleTextColor
        titleLabel.font = titleFont
        
        descriptionLabel.text = object.description
        descriptionLabel.textColor = descriptionTextColor
        descriptionLabel.font = descriptionFont
    }
    
    // MARK: - Private methods
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
        addInnerShadow(to: [.bottom])
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            /// Title label constraints
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            /// Description label constraints
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ]
        
        constraints.forEach {
            $0.isActive = true
        }
    }
}
