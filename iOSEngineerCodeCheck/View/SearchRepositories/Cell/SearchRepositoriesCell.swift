//
//  SearchRepositoriesCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/27.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Kingfisher

class SearchRepositoriesCell: UITableViewCell {
    
    // MARK: IBOutlet
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    
    // MARK: Properties
    
    static let reuseIdentifier = "SearchRepositoriesCell"
    static let rowHeight: CGFloat = 88
    static var nib: UINib {
        return UINib(nibName: "SearchRepositoriesCell", bundle: nil)
    }
    
    // MARK: Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Configuration
    
    func configureCell(title: String, desc: String?, stars: String, language: String?, avatarImage: String?) {
        titleLabel.text = title
        descriptionLabel.text = desc
        starsLabel.text = stars
        languageLabel.text = language
        
        if let avatarImage = avatarImage,
           let imageURL = URL(string: avatarImage) {
            avatarImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        } else {
            avatarImageView.image = nil
        }
    }
}
