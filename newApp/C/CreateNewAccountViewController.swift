//
//  CreateNewAccountViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/8/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Firebase

class CreateNewAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    func isValidNewPassword() -> Bool {
        
        switch Bool() {
        case !passwordTextField.text!.isEmpty:
            self.alertError(title: "Error", message: "No new password specified")
            return false
        case passwordTextField.text! == passwordConfirmTextField.text!:
            passwordConfirmTextField.text = ""
            self.alertError(title: "Error", message: "Password confirmation differ")
            return false
        default:
            return true
        }
    }
    
    @IBAction func createButtomClick(_ sender: UIButton) {
        
        guard isValidNewPassword() else { return }
        sender.isEnabled = false
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if error == nil {
                ref = Database.database().reference()
                user = Auth.auth().currentUser
                ref.child("users").child("\(user!.uid)").setValue(userInfo) { (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        self.performSegue(withIdentifier: "createPersonInfo", sender: nil)
                    }
                }
            } else {
                if let errorInfo = error { self.alertError(title: "Error", message: errorInfo.localizedDescription) }
            }
            sender.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboard()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmTextField.delegate = self
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
        
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordConfirmTextField.text = ""
    }
}

extension CreateNewAccountViewController {
    
    func alertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
}
