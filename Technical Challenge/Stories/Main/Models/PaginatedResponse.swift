//
//  PaginatedResponse.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct PaginatedResponse<T : Codable> {
    var data : T
    
    private var previousLink : String?
    private var nextLink : String?
    
    var nextLinkURL : URL? {
        get {
            if let nextLink = nextLink {
                let url = URL(string: nextLink)
                return url
            }
            return nil
        }
    }
    
    var previousLinkURL : URL? {
        get {
            if let previousLink = previousLink {
                let url = URL(string: previousLink)
                return url
            }
            return nil
        }
    }
    
    var isFirst : Bool {
        get {
            if previousLink == nil {
                return true
            } else {
                return false
            }
        }
    }
    
    var isLast : Bool {
        get {
            if nextLink == nil {
                return true
            } else {
                return false
            }
        }
    }
    
    init(data _data: T, previousLink _previousLink: String?, nextLink _nextLink: String?) {
        data = _data
        previousLink = _previousLink
        nextLink = _nextLink
    }
}
