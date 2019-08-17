//
//  LoginViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/8/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func LoginInButtomClick(_ sender: UIButton) {
        sender.isEnabled = false
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            if error == nil {
                self!.performSegue(withIdentifier: "mainMenuFromLogin", sender: nil)
            } else {
                self!.passwordTextField.text = ""
                if let errorInfo = error { self!.alertError(title: "Error", message: errorInfo.localizedDescription) }
            }
            sender.isEnabled = true
        }
    }
    
    @IBAction func CreateAccountButtomClick(_ sender: UIButton) {
        sender.isEnabled = false
        emailTextField.text = ""
        passwordTextField.text = ""
        self.performSegue(withIdentifier: "createAccount", sender: nil)
        sender.isEnabled = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboard()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

extension LoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func alertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
