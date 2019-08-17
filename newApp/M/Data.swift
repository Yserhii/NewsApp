//
//  Data.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/8/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import Foundation
import Firebase

var ref = Database.database().reference()
var user = Auth.auth().currentUser

var userInfo: [String : Any] =
                    ["name":      "",
                    "secondName": "",
                    "phone":      "",
                    "birthDate":  "",
                    "country" :   "",
                    "city" :      "",
                    "sourse" :    ""]

let allСountries: [String] =
                    ["Ukraine",
                    "Poland",
                    "Germany"]

let allСities: [String : [String]] =
                    ["Ukraine" : ["Kiev","Kharkov","Dnepr","Lviv"],
                    "Poland" : ["Warsaw","Krakow","Lodz","Poznan"],
                    "Germany" : ["Berlin","Munich","Koln","Hamburg"]]
