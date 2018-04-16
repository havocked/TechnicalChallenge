//
//  SubscriberCell.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 15/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

class SubscriberCell: UICollectionViewCell, EasyRegisteredCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    // Overriding the variable, force the app to redraw the corner radius of each images in cells
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.image = #imageLiteral(resourceName: "avatar_placeholder")
        avatarImageView.contentMode = .scaleAspectFill
        
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 2.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        
    }
    
    func configure(with model: SubscriberCellModel) {
        self.avatarImageView.kf.setImage(with: model.avatarURL, placeholder: model.avatarPlaceholderImage)
    }
    
}
