//
//  PaginatedResponse.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct PaginatedResponse<T : Codable> : Codable {
    var totalCount : Int
    var isResultIncomplete : Bool
    var items : [T]
    
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
    
    enum CodingKeys : String, CodingKey {
        case totalCount = "total_count"
        case isResultIncomplete = "incomplete_results"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let allValues = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try allValues.decode(Int.self, forKey: .totalCount)
        isResultIncomplete = try allValues.decode(Bool.self, forKey: .isResultIncomplete)
        items = try allValues.decode([T].self, forKey: .items)
    }
    
    mutating func setLinks(previous: String?, next: String?) {
        self.previousLink = previous
        self.nextLink = next
    }
}
