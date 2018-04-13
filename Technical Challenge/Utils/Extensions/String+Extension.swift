//
//  String+Extension.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        get {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        }
    }
    
    func trimWhitespaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
