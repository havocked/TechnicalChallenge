//
//  User.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

struct User : Codable {
    var id : Int
    var login : String
    var avatarURL : String
    
    enum CodingKeys : String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let allValues = try decoder.container(keyedBy: CodingKeys.self)
        id = try allValues.decode(Int.self, forKey: .id)
        login = try allValues.decode(String.self, forKey: .login)
        avatarURL = try allValues.decode(String.self, forKey: .avatarURL)
    }
}
