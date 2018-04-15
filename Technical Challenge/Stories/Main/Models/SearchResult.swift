//
//  Search.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 15/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct SearchResult<T : Codable> : Codable {
    
    var totalCount : Int
    var isResultIncomplete : Bool
    var items : [T]
    
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
}
