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
        
        switch repository.forks {
        case 0:
            fork = "No forks"
        case 1:
            fork = "1 fork"
        default:
            fork = "REPO_MULTI_FORKS".localize(args: repository.forks)
        }
        
        avatarURL = URL(string: repository.owner.avatarURL)
    }
}
