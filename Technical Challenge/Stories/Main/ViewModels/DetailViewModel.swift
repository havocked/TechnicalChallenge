//
//  DetailViewModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 15/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

final class DetailViewModel {
    
    private var repository: Repository
    
    var totalSubscribers : String {
        get {
            return "\(repository.totalWatchers)\nwatchers"
        }
    }
    
    var repoName : String {
        get {
            return repository.name
        }
    }
    
    init(repository: Repository) {
        self.repository = repository
    }
}
