//
//  MessageCell.swift
//  DragonTalk
//
//  Created by David Murges on 2/10/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UICollectionViewCell {
    
    var messagesController: MessagesController?
    

    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 12)
        tv.backgroundColor = UIColor.white
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .lightGray
        return label
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    }()
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        
        let imageView = tapGesture.view as? UIImageView
        self.messagesController?.performZoom(imageView!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        addSubview(textView)
        addSubview(profileImageView)
        textView.addSubview(messageImageView)
        addSubview(userName)
        
        
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        messageImageView.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: textView.heightAnchor).isActive = true
        
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        userName.leftAnchor.constraint(equalTo: leftAnchor, constant: 44).isActive = true
        userName.bottomAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        userName.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 15).isActive = true


        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
