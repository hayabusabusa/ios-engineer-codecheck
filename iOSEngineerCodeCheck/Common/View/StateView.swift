//
//  StateView.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/29.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// `StateView` を表示させる `UIViewController` に適合させる Protocol.
protocol StateViewable where Self: UIViewController {
    /// `StateView` を保持.
    var stateView: StateView { get }
    /// `StateView` を制約付きで `addSubView()` する.
    func setupStateView()
}

extension StateViewable {
    func setupStateView() {
        stateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stateView)
        
        NSLayoutConstraint.activate([
            stateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}

/// ロード中、エラーの発生などを表示する View.
class StateView: UIView {
    
    // MARK: Enum
    
    enum State {
        case none
        case loading
        case empty
        case error
    }
    
    // MARK: Properties
    
    private var emptyImage: UIImage?
    private var emptyTitle: String?
    private var emptyContent: String?
    
    private var errorImage: UIImage?
    private var errorTitle: String?
    private var errorContent: String?
    
    // MARK: Views
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alpha = 0
        stackView.spacing = 4
        stackView.isHidden = true
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = emptyImage
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = emptyTitle
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        return titleLabel
    }()
    
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = emptyContent
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .lightGray
        contentLabel.textAlignment = .center
        contentLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return contentLabel
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.alpha = 0
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(frame: CGRect,
         emptyImage: UIImage? = nil,
         emptyTitle: String? = nil,
         emptyContent: String? = nil,
         errorImage: UIImage? = nil,
         errorTitle: String? = nil,
         errorContent: String? = nil) {
        super.init(frame: frame)
        self.emptyImage = emptyImage
        self.emptyTitle = emptyTitle
        self.emptyContent = emptyContent
        self.errorImage = errorImage
        self.errorTitle = errorTitle
        self.errorContent = errorContent
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private func commonInit() {
        isExclusiveTouch = true
        setupViews()
    }
}

// MARK: - Private method

extension StateView {
    
    private func setupViews() {
        // StackView
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // ImageView
        stackView.addArrangedSubview(imageView)
        // TitleLabel
        stackView.addArrangedSubview(titleLabel)
        // ContentLabel
        stackView.addArrangedSubview(contentLabel)
        // Indicator
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func animateIndicator(isHidden: Bool) {
        // NOTE: Start activity indicator.
        if !isHidden {
            indicator.startAnimating()
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.indicator.alpha = isHidden ? 0 : 1
                       },
                       completion: { _ in
                        self.indicator.isHidden = isHidden
                        // NOTE: Stop activity indicator animation when finish animation.
                        if isHidden {
                            self.indicator.stopAnimating()
                        }
                       })
    }
    
    private func animateStackView(isHidden: Bool) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.stackView.alpha = isHidden ? 0 : 1
                       },
                       completion: { _ in
                        self.stackView.isHidden = isHidden
                       })
    }
}

// MARK: - Public method

extension StateView {
    
    func setState(of state: State) {
        isHidden = state == .none
        imageView.image = state == .error ? errorImage : emptyImage
        titleLabel.text = state == .error ? errorTitle : emptyTitle
        contentLabel.text = state == .error ? errorContent : emptyContent
        switch state {
        case .none:
            animateIndicator(isHidden: true)
            animateStackView(isHidden: true)
        case .loading:
            animateIndicator(isHidden: false)
            animateStackView(isHidden: true)
        case .empty, .error:
            animateIndicator(isHidden: true)
            animateStackView(isHidden: false)
        }
    }
}
