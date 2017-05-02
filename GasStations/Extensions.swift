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
}
