//
//  TCError.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 12/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import Foundation
import UIKit


/// Custom Error enum for the project
public enum TCError {
    
    case error(Error)
    case message(title:String, message: String)
    
    var message : String {
        switch self {
        case .error(let error):
            if let _ = error as? URLError {
                return "ERROR_INTERNET".localized
            } else {
                return "ERROR_UNKNOWN".localized
            }
        case .message(_, let message):
            return message
        }
    }
    
    var title : String {
        switch self {
        case .error:
            return "ERROR_ALERT_TITLE".localized
        case .message(let title, _):
            return title
        }
    }
}

extension TCError : CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .error(let error):
                return "❌ \(error.localizedDescription)"
            case .message(let title, let message):
                return "❌ Error : \(title) - \(message)"
            }
        }
    }
}

