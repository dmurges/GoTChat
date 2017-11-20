//
//  extensions.swift
//  DragonTalk
//
//  Created by David Murges on 25/9/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImageUsingCache(urlString: String){
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject ) as? UIImage{
            self.image = cachedImage
            return
        }
        
        
        
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data!)
                }
                
                
                
            }
            
            
        }).resume()
    }
    
    
}
