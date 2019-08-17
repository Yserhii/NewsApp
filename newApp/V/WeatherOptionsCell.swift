//
//  WeatherOptionsCell.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/13/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit

class WeatherOptionCell: UITableViewCell {
    
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var inDay: UILabel!
    @IBOutlet weak var inEvning: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
