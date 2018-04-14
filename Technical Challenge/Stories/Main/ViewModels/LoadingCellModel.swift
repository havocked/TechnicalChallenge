//
//  LoadingCellModel.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 14/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct LoadingCellModel {
    
    var showActivityIndicator : Bool
    
    init(loadingStatus: MainStatus) {
        switch loadingStatus {
        case .fetchingFirstPage, .idle, .refreshing:
            showActivityIndicator = false
        case .fetchingNextPage:
            showActivityIndicator = true
        }
    }
}
