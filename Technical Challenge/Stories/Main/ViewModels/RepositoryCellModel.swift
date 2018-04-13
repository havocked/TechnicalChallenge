//
//  RepositoryCellModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation
import UIKit

struct RepositoryCellModel {
    var title : String
    var description : String
    var fork : String
    var avatarURL : URL?
    var avatarPlaceholderImage = #imageLiteral(resourceName: "avatar_placeholder")
    
    init(repository: Repository) {
        title = repository.name
        description = repository.description ?? "No description"
        fork = "\(repository.forks) \(repository.forks > 1 ? "forks" : "fork")"
        avatarURL = URL(string: repository.owner.avatarURL)
    }
}
