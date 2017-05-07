//
//  Extensions.swift
//  GasStations
//
//  Created by anton Shepetuha on 02.05.17.
//  Copyright © 2017 anton Shepetuha. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func applyGradient(_ colors: [UIColor],_ locations: [NSNumber]) {
        let gradient = CAGradientLayer()
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        
        }
        
        gradient.colors = cgColors
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
        
    }
    
    func addShadow( opacity: Float,radius: CGFloat){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
    }
}

extension UIColor {
    open class var noActiveButton: UIColor { get {
        return UIColor.init(red: 119 / 255, green: 119 / 255, blue: 119 / 255, alpha: 1)
        }
    }
}



