//
//  UIView+Extension.swift
//  Technical Challenge
//
//  Created by Nataniel Martin on 13/04/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Centering view with another view (as long as they are in the same parent "superview")
    func bindWithCenterOfViewBounds(otherView: UIView) {
        
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let centerXContraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: otherView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: otherView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        superview.addConstraints([centerXContraint, centerYConstraint])
    }
    
    /// View will pulsate (bigger to smaller) only one time
    public func pulse(with color: UIColor? = nil) {
        self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            
            self.transform = CGAffineTransform.identity
            self.layer.shadowOpacity = 0.0
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }, completion: nil)
    }
}
