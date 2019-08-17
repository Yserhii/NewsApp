//
//  HomeOptionsCell.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/15/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit

class HomeOptionsCell: UITableViewCell {

    let title: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Sample text"
        return label
    }()
    
    let author: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Sample text"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .darkGray
        
        addSubview(author)
        author.translatesAutoresizingMaskIntoConstraints = false
        author.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        author.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        author.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        title.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 2).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
