//
//  ForumCell.swift
//  DragonTalk
//
//  Created by David Murges on 2/10/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit

class ForumCell: UITableViewCell {
    
    
    var message: Message? {
        didSet{
            
        }
    }
    
    
    
    var forum: Forum? {
        didSet{
            
            textLabel?.text = forum?.Title
//            if let seconds = message?.timestamp?.doubleValue {
//                let timestampDate = NSDate(timeIntervalSince1970: seconds)
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm:ss a"
//                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
//            }
            

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 20, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
    }
    
    
    let forumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(forumImage)
        addSubview(timeLabel)
        
        
        forumImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        forumImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        forumImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        forumImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
