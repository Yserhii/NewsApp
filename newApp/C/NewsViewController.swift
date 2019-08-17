//
//  NewsViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/16/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

class NewsViewController: UIViewController {
    
    @IBOutlet weak var titleNew: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var authot: UILabel!
    @IBOutlet weak var higthumage: NSLayoutConstraint!
    var countNews: Int = 0
    
    @IBAction func nextNews(_ sender: UIBarButtonItem) {
        
        indexNew! += 1
        if indexNew! >= arrayNews.count {
            indexNew! = 0
        }
        showNews()
    }
    
    @IBAction func openNewsInSafari(_ sender: UIButton) {
        
        if let url = URL(string: arrayNews[indexNew!]?["url"].string ?? "") {
            UIApplication.shared.open(url)
        } else {
            self.alertError(title: "Error", message: "No connection to the news server")
        }
    }
    
    func showNews() {
        
        image.isHidden = false
        titleNew.text = arrayNews[indexNew!]?["title"].string ?? ""
        content.text = arrayNews[indexNew!]?["content"].string ?? ""
        authot.text = "Authors: \(arrayNews[indexNew!]?["author"].string ?? "")"
        
        if let newsImage = URL(string: arrayNews[indexNew!]?["urlToImage"].string ?? "") {
            if let isNewsImage = try? Data(contentsOf: newsImage) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: isNewsImage)
                    self.image.contentMode = .scaleAspectFit
                }
            } else { image.isHidden = true }
        } else { image.isHidden = true }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        self.countNews = arrayNews.count
        showNews()
    }
}

extension NewsViewController {
    
    func alertError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
