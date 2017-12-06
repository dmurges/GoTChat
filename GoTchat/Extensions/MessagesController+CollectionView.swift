//
//  MessagesController+CollectionView.swift
//  GoTchat
//
//  Created by David Murges on 6/12/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit

extension MessagesController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
            
        }else {
            return messages.count
        }
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellId, for: indexPath) as! MessageHeaderCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        cell.messagesController = self
        
        if indexPath.section == 0 {
            
            let message = forum?.Title
            headerCell.textView.text = message
            return headerCell
            
            
        }else {
            
            let message = messages[indexPath.item]
            cell.textView.text = message.message
            cell.userName.text = message.fromUserName
            
            if let profileImageUrl = self.user?.profileImageUrl {
                cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
            }
            
            if message.imageUrl != nil {
                cell.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
            
            if let messageImageUrl = message.imageUrl {
                cell.messageImageView.loadImageUsingCache(urlString: messageImageUrl)
                cell.messageImageView.isHidden = false
                cell.userName.isHidden = true
            } else {
                cell.messageImageView.isHidden = true
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(10, 10, 10, 10)
        }else {
            return UIEdgeInsetsMake(5, 5, 5, 5)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        if indexPath.section == 0 {
            
            if let text = forum?.Title {
                height = estimateFrameForText(text: text).height + 50
            }
            return CGSize(width: view.frame.width , height: height)
            
        }else {
            
            
            if let text = messages[indexPath.item].message {
                height = estimateFrameForText(text: text).height + 20
            } else if let imageWidth = messages[indexPath.item].imageWidth?.floatValue, let imageHeight = messages[indexPath.item].imageHeight?.floatValue {
                
                
                height = CGFloat(imageHeight / imageWidth * 200)
            }
            
            return CGSize(width: view.frame.width , height: height)
        }
        
    }
}
