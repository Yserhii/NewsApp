//
//  ExtensionString.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/10/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    var isAlphabet: Bool {
        return !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if self.count != "+XXXXXXXXXXXX".count || self.first != "+" { return false }
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else { return false }
        } catch { return false }
    }
}
