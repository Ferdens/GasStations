//
//  GasStationCell.swift
//  GasStations
//
//  Created by anton Shepetuha on 06.05.17.
//  Copyright © 2017 anton Shepetuha. All rights reserved.
//

import UIKit

class GasStationCell: UITableViewCell {

    @IBOutlet weak var distanseLabel: UILabel!
    @IBOutlet weak var streetName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
