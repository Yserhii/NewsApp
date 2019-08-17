//
//  ExtensionUIViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/10/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
