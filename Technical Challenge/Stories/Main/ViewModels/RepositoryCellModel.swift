//
//  RepositoryCellModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct RepositoryCellModel {
    var title : String
    var description : String
    var fork : String
    
    init(repository: Repository) {
        title = repository.name
        description = repository.description ?? "No description"
        fork = "\(repository.forks) \(repository.forks > 1 ? "forks" : "fork")"
    }
}
