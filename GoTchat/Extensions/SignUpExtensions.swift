//
//  SignUpExtensions.swift
//  DragonTalk
//
//  Created by David Murges on 9/10/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import Photos

extension SignUpController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleImagePicked() {
        let picker = UIImagePickerController()
        
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let image = selectedImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
