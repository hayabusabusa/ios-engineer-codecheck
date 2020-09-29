//
//  Button.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/28.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class Button: UIButton {

    // MARK: IBInspectable

    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderColor: UIColor = .clear
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = .clear
    @IBInspectable var shadowOffset: CGSize = .zero
    @IBInspectable var shadowOpacity: Float = 0

    // MARK: Overrides

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.4
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }

    // MARK: Configuration

    private func configure() {
        isExclusiveTouch = true
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
}
