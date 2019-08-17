//
//  RequestClass.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/16/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class RequestClass {
    
    func userInfoisEmpty(completationHandler: @escaping(Bool)->Void) {
        
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                if (dick.isEmpty == true  || dick["name"] as? String == "" || dick["secondName"] as? String == ""
                    || dick["phone"] as? String == "") {
                    completationHandler(true)
                } else {
                    completationHandler(false)
                }
            }
        }
    }
    
    func getCity(completationHandler: @escaping(String?)->Void) {
        
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                guard dick.isEmpty == false else { return }
                completationHandler(dick["city"] as? String)
            }
        }
    }
    
    func getWeather(city: String?, completationHandler: @escaping(JSON?)->Void) {
        
        let myKey: String = "aa2b8d5e36eb4aa1a76135231191208"
        let reqUrlCurrent = "https://api.apixu.com/v1/forecast.json?key=\(myKey)&q=\(city ?? "")&days=7"

        Alamofire.request(reqUrlCurrent).responseJSON { response in
            if response.result.isSuccess {
                completationHandler(JSON(response.data!))
            } else {
                completationHandler(nil)
            }
        }
    }
    
    func getSourseNews(completationHandler: @escaping(JSON?)->Void) {
        
        let myKey: String = "0fcf82a02cb7434c8d8d7de6a57e1afc"
        let reqUrlCurrent = "https://newsapi.org/v2/sources?apiKey=\(myKey)"
        
        Alamofire.request(reqUrlCurrent).responseJSON { response in
            if response.result.isSuccess {
                completationHandler(JSON(response.data!))
            } else {
                completationHandler(nil)
            }
        }
    }
    
    func getNews(tabkeSourse: [String : String], completationHandler: @escaping(JSON?)->Void) {
        
        var selectSourses = ""
        for sours in tabkeSourse {
            selectSourses += "\(sours.key),"
        }
        if selectSourses != "" {
            selectSourses.removeLast()
        }
        let myKey: String = "0fcf82a02cb7434c8d8d7de6a57e1afc"
        let reqUrlCurrent = "https://newsapi.org/v2/top-headlines?sources=\(selectSourses)&apiKey=\(myKey)"
        
        Alamofire.request(reqUrlCurrent).responseJSON { response in
            if response.result.isSuccess {
                completationHandler(JSON(response.data!))
            } else {
                completationHandler(nil)
            }
        }
    }
    
    func getSourses(completationHandler: @escaping([String : String]?)->Void) {
        var allSsourse: [String : String] = [:]
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            DispatchQueue.main.async {
                let dick = DataSnapshot.value as? [String : Any] ?? [:]
                guard dick.isEmpty == false else { return }
                let soursesString = dick["sourse"] as? String
                if let soursesArr = soursesString?.split(separator: ",") {
                    for oneSsourse in soursesArr {
                        allSsourse.updateValue("\(oneSsourse)", forKey: "\(oneSsourse)")
                    }
                }
                completationHandler(allSsourse)
            }
        }
    }
}
