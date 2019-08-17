//
//  MainMenuViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/8/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class ContanierViewController: UIViewController {
    
    var requestManager = RequestClass()
    var menuController: MenuController!
    var homeController: HomeController!
    var centerController: UIViewController!
    var flagForfirstEnter: Bool = true
    var isExpanded = false
    var selectedCity: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    func configerHomeController() {
        homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configerMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func singOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("Exit")
        self.performSegue(withIdentifier: "backToLoginFromMainMenu", sender: nil)
    }

    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .News:
            self.getNews()
        case .Profile:
            self.performSegue(withIdentifier: "changePersonInfo", sender: nil)
        case .Source:
            self.performSegue(withIdentifier: "Source", sender: nil)
        case .Weather:
            self.getWeather()
        case .Exit:
            self.singOut()
        }
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue) {
        self.getNews()
        self.homeController.tableView.reloadData()
        print(segue.identifier!)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userInfoisEmpty()
        self.configerHomeController()
        self.getCity()
        self.getSourseNews()
        self.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension ContanierViewController {
    
    func getWeather() {
        requestManager.getWeather(city: selectedCity, completationHandler: {(responds) in
            if responds != nil {
                allInfoWeather = responds
                self.performSegue(withIdentifier: "Weather", sender: nil)
            } else {
                self.alertError(title: "Error", message: "No connection to the weather server")
            }
        })
    }
    
    func userInfoisEmpty() {
        
        requestManager.userInfoisEmpty(completationHandler: {(response) in
            if response == true && self.flagForfirstEnter {
                self.flagForfirstEnter = false
                self.performSegue(withIdentifier: "changePersonInfo", sender: nil)
            }
        })
    }
    
    func getCity() {
        requestManager.getCity(completationHandler: {(response) in
            if let city = response {
                self.selectedCity = city
            }
        })
    }
    
    func getSourseNews() {
        requestManager.getSourseNews(completationHandler: {(response) in
            if response != nil {
                allSoursesNews = response
            } else {
                self.alertError(title: "Error", message: "No connection to the news sourse server")
            }
        })
    }
    
    func getNews() {
        requestManager.getSourses(completationHandler: {(response) in
            if response != nil {
                sourse = response!
            }
            self.requestManager.getNews(tabkeSourse: sourse, completationHandler: {(response) in
                if response != nil {
                    allNews = response
                    arrayNews = response?["articles"].array ?? []
                    self.homeController.tableView.reloadData()
                } else {
                    self.alertError(title: "Error", message: "No connection to the news server")
                }
            })
        })
    }
    
    func alertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ContanierViewController: HomeControllerDelegate {
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        animateStatusBar()
    }
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?, news: Int?) {
        if news == nil {
            if !isExpanded {
                configerMenuController()
            }
            isExpanded = !isExpanded
            animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
        } else {
            indexNew = news!
            self.performSegue(withIdentifier: "OneNews", sender: nil)
        }
    }
}
