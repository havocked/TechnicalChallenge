//
//  TCDesign.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

// Custom colors / fonts goes there

extension UILabel {
    func bigTitle() {
        self.font = UIFont.boldSystemFont(ofSize: 18)
        self.textColor = UIColor.darkGray
    }
    
    func smallDescription() {
        self.font = UIFont.systemFont(ofSize: 15)
        self.textColor = UIColor.gray
    }
    
    func smallText() {
        self.font = UIFont.systemFont(ofSize: 12)
        self.textColor = UIColor.lightGray
    }
}
