//
//  ImageView.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/27.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    // MARK: IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = .clear

    // MARK: Initializer
    
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

    private func configure() {
        isExclusiveTouch = true

        backgroundColor = .clear
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
