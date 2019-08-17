//
//  MenuOptions.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/11/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case News
    case Profile
    case Source
    case Weather
    case Exit
    
    var description: String {
        switch  self {
        case .News: return "News"
        case .Profile: return "Profile"
        case .Source: return "Source"
        case .Weather: return "Weather"
        case .Exit: return "Exit"
        }
    }
    
    var image: UIImage {
        switch  self {
        case .News: return UIImage(named: "News") ?? UIImage()
        case .Profile: return UIImage(named: "Profile") ?? UIImage()
        case .Source: return UIImage(named: "Source") ?? UIImage()
        case .Weather: return UIImage(named: "Weather") ?? UIImage()
        case .Exit: return UIImage(named: "Exit") ?? UIImage()
        }
    }

}
