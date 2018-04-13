//
//  RepositoryCell.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryCell: UITableViewCell, EasyRegisteredCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.bigTitle()
        descriptionLabel.smallDescription()
        forkLabel.smallText()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
    }
    
    func configure(model: RepositoryCellModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
        self.forkLabel.text = model.fork
        self.avatarImageView.kf.setImage(with: model.avatarURL, placeholder: model.avatarPlaceholderImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
    }
    
}
