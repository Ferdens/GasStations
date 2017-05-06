//
//  PinView.swift
//  GasStations
//
//  Created by anton Shepetuha on 06.05.17.
//  Copyright © 2017 anton Shepetuha. All rights reserved.
//

import UIKit

class PinView: UIView {
    
    @IBOutlet weak var priceLabel           : UILabel!
    @IBOutlet weak var streetNameLabel      : UILabel!
    @IBOutlet weak var gasStationImageView  : UIImageView!
    
    var nibName = "PinView"
 
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        
        return view
    }
    
}
