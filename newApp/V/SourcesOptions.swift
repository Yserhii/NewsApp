//
//  SourcesOptions.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/13/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import SwiftyJSON

class SourcesOptionsCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var textDescription: UILabel!
    var id: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var data: JSON? {
        didSet {
            if data != nil {
                name.text = data?["name"].string ?? ""
                category.text = "Category: \(data?["category"].string ?? "")"
                textDescription.text = data?["description"].string ?? ""
                id = data!["id"].string ?? ""
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
