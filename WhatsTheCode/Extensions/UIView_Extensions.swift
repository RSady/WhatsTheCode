//
//  UIView_Extensions.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/4/21.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func makeCircular() {
        layer.cornerRadius = frame.height / 2
    }
    
    func addStroke() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.label.cgColor
    }
    
    func removeStroke() {
        layer.borderWidth = 0
        layer.borderColor = nil
    }
}
