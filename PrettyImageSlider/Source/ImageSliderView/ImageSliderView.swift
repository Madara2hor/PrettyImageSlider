import UIKit

open class ImageSliderView: UIImageView {
    public var objectStyle: ImageSliderViewStyle = ImageSliderViewStyle() {
        didSet {
            titleLabel.textColor = objectStyle.titleTextColor
            titleLabel.font = objectStyle.titleFont
            descriptionLabel.textColor = objectStyle.descriptionTextColor
            descriptionLabel.font = objectStyle.descriptionFont
        }
    }
    public var imageTitle: String? { object?.title }
    public var imageDescription: String? { object?.description }
    
    private var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .one
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .two
        return label
    }()
    
    private var object: ImageSliderViewObject?
    
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.removeAllShadows()
        shadowView.addInnerShadow(to: [.bottom])
    }
    
    public func bind(with object: ImageSliderViewObject) {
        self.object = object
        self.image = object.image
        
        titleLabel.text = object.title
        descriptionLabel.text = object.description
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    private func setupViews() {
        addSubview(shadowView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupLayout() {        
        NSLayoutConstraint.activate([
            /// Shadow view constraints
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
        ])
    }
}
