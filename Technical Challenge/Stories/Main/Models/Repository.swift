//
//  Repository.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

//https://developer.github.com/v3/repos/#list-all-public-repositories

import Foundation

struct Repository : Codable {
    var id : Int
    var name : String
    var fullName : String
    var description : String?
    var forks : Int
    var owner : Owner
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case forks
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let allValues = try decoder.container(keyedBy: CodingKeys.self)
        id = try allValues.decode(Int.self, forKey: .id)
        name = try allValues.decode(String.self, forKey: .name)
        fullName = try allValues.decode(String.self, forKey: .fullName)
        description = try allValues.decodeIfPresent(String.self, forKey: .description)
        forks = try allValues.decode(Int.self, forKey: .forks)
        owner = try allValues.decode(Owner.self, forKey: .owner)
    }
}
