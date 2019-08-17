//
//  PersonInfoViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/8/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Firebase

class PersonInfoViewController: UIViewController, UITextFieldDelegate {

    var selectedCountry: String? = "Ukraine"
    var selectedCity: String? = "Kiev"
    var selectedBirthDate: String?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    @IBOutlet weak var birthDate: UIDatePicker!
    @IBOutlet weak var county: UIPickerView!
    @IBOutlet weak var city: UIPickerView!

    @IBAction func backToMainMenu(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            let dick = DataSnapshot.value as? [String : Any] ?? [:]
            if dick.isEmpty == false {
                if dick["name"] as? String == "" || dick["secondName"] as? String == "" || dick["phone"] as? String == "" {
                    self.alertError(title: "Error", message: "Fill in information about yourself")
                    return
                } else {
                    self.performSegue(withIdentifier: "backToMainMenuFromUserInfo", sender: nil)
                }
            } else {
                self.alertError(title: "Error", message: "Fill in information about yourself")
            }
            sender.isEnabled = true
        }
    }
    
    func saveInBoxUserInfo() {
        
        ref.child("users").child("\(user!.uid)").observe(.value) { (DataSnapshot) in
            let dick = DataSnapshot.value as? [String : Any] ?? [:]
            guard dick.isEmpty == false else { return }
            self.nameTextField.text = dick["name"] as? String
            self.secondNameTextField.text = dick["secondName"] as? String
            self.phoneNumberTextField.text = dick["phone"] as? String
            self.selectedBirthDate = dick["birthDate"] as? String
            self.selectedCountry = dick["country"] as? String
            self.selectedCity = dick["city"] as? String
            
            if self.selectedBirthDate == "" || self.selectedBirthDate == nil {
                self.selectedBirthDate = "01/01/2019"
            }
            self.birthDate.date = self.convertDate(dateString: self.selectedBirthDate!)
            
            if self.selectedCountry == "" || self.selectedCountry == nil ||
                            self.selectedCity == "" || self.selectedCity == nil {
                self.selectedCountry = "Ukraine"
                self.selectedCity = "Kiev"
            }
            
            if let row = allСountries.firstIndex(of: self.selectedCountry!) {
                self.county.selectRow(row, inComponent: 0, animated: false)
                self.city.reloadAllComponents()
            }
            if let row = allСities[self.selectedCountry!]!.firstIndex(of: self.selectedCity!) {
                self.city.selectRow(row, inComponent: 0, animated: false)
            }
            if sourse == [:] {
                sourse = ["abc-news" : "abc-news", "abc-news-au" : "abc-news-au", "aftenposten" : "aftenposten", "al-jazeera-english" : "al-jazeera-english", "ansa" : "ansa"]
                var selectSourses = ""
                for sours in sourse {
                    selectSourses += "\(sours.key),"
                }
                if selectSourses != "" {
                    selectSourses.removeLast()
                }
                ref.child("users").child("\(user!.uid)").child("sourse").setValue(selectSourses)
            }
        }
    }
    
    func isValidUserInfo() -> Bool {
        
        nameTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        secondNameTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneNumberTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        switch Bool() {
            case nameTextField.text!.isAlphabet:
                nameTextField.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.9841606326)
                self.alertError(title: "Error", message: "Use only letters of the alphabet")
                return false
            case secondNameTextField.text!.isAlphabet:
               secondNameTextField.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.9841606326)
               self.alertError(title: "Error", message: "Use only letters of the alphabet")
                return false
            case phoneNumberTextField.text!.isPhoneNumber:
                phoneNumberTextField.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.9841606326)
                 self.alertError(title: "Error", message: "Format phone number +XXXXXXXXXXXX")
                return false
            default:
                return true
        }
    }
    
    @IBAction func saveNewInfo(_ sender: UIBarButtonItem) {
        
        if !nameTextField.text!.isEmpty && !secondNameTextField.text!.isEmpty && !phoneNumberTextField.text!.isEmpty {
            guard isValidUserInfo() else { return }
            sender.isEnabled = false
            ref.child("users").child("\(user!.uid)").child("name").setValue(nameTextField.text)
            ref.child("users").child("\(user!.uid)").child("secondName").setValue(secondNameTextField.text)
            ref.child("users").child("\(user!.uid)").child("phone").setValue(phoneNumberTextField.text)
            ref.child("users").child("\(user!.uid)").child("birthDate").setValue(convertDate(datePicker: birthDate))
            ref.child("users").child("\(user!.uid)").child("country").setValue(selectedCountry)
            ref.child("users").child("\(user!.uid)").child("city").setValue(selectedCity)
            self.performSegue(withIdentifier: "backToMainMenuFromUserInfo", sender: nil)
        } else {
             self.alertError(title: "Error", message: "Fill in all the fields")
        }
         sender.isEnabled = true
    }
    
    func isValidNewPassword() -> Bool {
        
        switch Bool() {
        case !newPasswordTextField.text!.isEmpty:
            self.alertError(title: "Error", message: "No new password specified")
            return false
        case newPasswordTextField.text! == newPasswordConfirmTextField.text!:
            newPasswordConfirmTextField.text = ""
            self.alertError(title: "Error", message: "Password confirmation differ")
            return false
        default:
            return true
        }
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        
        guard isValidNewPassword() else { return }
        sender.isEnabled = false
        Auth.auth().currentUser?.updatePassword(to: newPasswordTextField.text!) { (error) in
            if let errorInfo = error {
                self.alertError(title: "Error", message: errorInfo.localizedDescription)
            } else {
                self.newPasswordTextField.text = ""
                self.newPasswordConfirmTextField.text = ""
                self.alertError(title: "Success", message: "Password was changed")
            }
            sender.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboard()
        county.delegate = self
        city.delegate = self
        saveInBoxUserInfo()
        birthDate.set18YearValidation()
        self.nameTextField.delegate = self
        self.secondNameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.newPasswordTextField.delegate = self
        self.newPasswordConfirmTextField.delegate = self
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        birthDate.setValue(UIColor.white, forKeyPath: "textColor")
    }
}

extension PersonInfoViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    func convertDate(datePicker: UIDatePicker) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: datePicker.date)
    }
    
    func convertDate(dateString: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: dateString)!
    }
    
    func alertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension PersonInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.county {
            return allСountries.count
        } else {
            return allСities[selectedCountry ?? "Ukraine"]?.count ?? 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.county {
            return allСountries[row]
        } else {
            return allСities[selectedCountry ?? "Ukraine"]?[row] ?? "Kiev"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.county {
            selectedCountry = allСountries[row]
            self.city.selectRow(0, inComponent: 0, animated: false)
            selectedCity = allСities[selectedCountry!]?[0]
            city.reloadAllComponents()
        } else {
            selectedCity = allСities[selectedCountry!]?[row]
        }
    }
}
