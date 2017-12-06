//
//  HeaderCell.swift
//  DragonTalk
//
//  Created by David Murges on 3/10/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit

class MessageHeaderCell: UICollectionViewCell {
    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 22)
        tv.textColor = UIColor.lightGray
        tv.backgroundColor = UIColor.clear
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
