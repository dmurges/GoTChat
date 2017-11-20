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
        tv.backgroundColor = UIColor(red: 206/255, green: 22/255, blue: 47/255, alpha: 0.4)
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
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
        
        
        addSubview(textView)
        addSubview(profileImageView)
        
        
        
        textView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: textView.heightAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        profileImageView.rightAnchor.constraint(equalTo: textView.rightAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
