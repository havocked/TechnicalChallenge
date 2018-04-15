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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.image = #imageLiteral(resourceName: "avatar_placeholder")
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
    }
    
    func configure(with model: SubscriberCellModel) {
        self.avatarImageView.kf.setImage(with: model.avatarURL, placeholder: model.avatarPlaceholderImage)
    }
    
}
