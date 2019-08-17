//
//  HomeController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/11/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifer = "HomeOptionCell"

class HomeController: UIViewController, UIScrollViewDelegate {
    
    private var fetchingMore = false
    var tableView: UITableView!
    var delegate: HomeControllerDelegate?
    private let refreshControl = UIRefreshControl()
    var requestManager = RequestClass()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        comfigureTableView()
        configureMavigatiomBar()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        self.getNews()
    }
    
    func comfigureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(HomeOptionsCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.backgroundColor = .darkGray
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil, news: nil)
        
    }
    
    func configureMavigatiomBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Side Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
}

extension HomeController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHight = scrollView.contentSize.height
        
        if offsetY > contentHight - scrollView.frame.height * 4 {
            if !fetchingMore {
                beginBatchFatch()
            }
        }
    }
    
    func beginBatchFatch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            let newNews = arrayNews
            arrayNews.append(contentsOf: newNews)
            self.fetchingMore = false
            self.tableView.reloadData()
        }
    }
    
    func getNews() {
        
        self.requestManager.getNews(tabkeSourse: sourse, completationHandler: {(response) in
            if response != nil {
                allNews = response
                arrayNews = response?["articles"].array ?? []
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! HomeOptionsCell
        cell.title.text = "\(arrayNews[indexPath.row]?["title"].string ?? "")"
        cell.author.text = "\(arrayNews[indexPath.row]?["source"]["name"].string ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.handleMenuToggle(forMenuOption: nil, news: indexPath.row)
    }
}
