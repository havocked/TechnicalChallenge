//
//  SubscriberCellModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 15/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

struct SubscriberCellModel {

    var avatarURL : URL?
    var avatarPlaceholderImage = #imageLiteral(resourceName: "avatar_placeholder")
    
    init(user: User) {
        self.avatarURL = URL(string: user.avatarURL)
    }
}
