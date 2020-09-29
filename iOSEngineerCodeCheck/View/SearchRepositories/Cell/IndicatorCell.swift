//
//  IndicatorCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/29.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class IndicatorCell: UITableViewCell {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    
    static let reuseIdentifier = "IndicatorCell"
    static var nib: UINib {
        return UINib(nibName: "IndicatorCell", bundle: nil)
    }
    
    // MARK: Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Configurations
    
    func configureCell() {
        activityIndicatorView.startAnimating()
    }
}
