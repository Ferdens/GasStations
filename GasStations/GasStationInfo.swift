//
//  GasStationInfo.swift
//  GasStations
//
//  Created by anton Shepetuha on 06.05.17.
//  Copyright © 2017 anton Shepetuha. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Station {
    
    var streetName          = ""
    var price      : Double = 0
    var logoImage           = UIImage()
    var longitude : CLLocationDegrees = 0
    var latitude  : CLLocationDegrees = 0
    
    init(_ streetName: String,_ price: Double,_ logoImage: UIImage,_ latitude: Double, _ longitude: Double) {
        self.streetName = streetName
        self.price      = price
        self.logoImage  = logoImage
        self.latitude  = latitude
        self.longitude  = longitude
    }
}
