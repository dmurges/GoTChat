//
//  SignUpController.swift
//  DragonTalk
//
//  Created by David Murges on 11/9/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SignUpController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignUpView()
        setupSignUpButton()
        imagePicker()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func imagePicker() {
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicked)))
        imageView.isUserInteractionEnabled = true
    }
    
    @IBAction func didSignUp(_ sender: Any) {
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form not valid")
            return
        }
        
        FIRAuth.auth()!.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                self.emailAlert()
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.imageView.image!){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": username, "email": email, "profileImageUrl":profileImageUrl]
                        self.uploadInformation(uid: uid, values: values)
                    }
                    
                })
            }
        
        })
    }
    
    private func uploadInformation (uid: String , values: [String: String]) {
        let dataRef = FIRDatabase.database().reference(fromURL: "https://dragongossip-d45b4.firebaseio.com/")
        let userReference = dataRef.child("users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (error, dataRef) in
            
            if error != nil {
                print(error!)
                return
            }
            
            print("Saved succesfully")
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func didHaveAccount(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func emailAlert() {
        let alertController = UIAlertController(title: "Email already exists/invalid or unsafe password", message: "Please choose a different email or password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func setupSignUpButton() {
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.layer.masksToBounds = true
    }
    
    
    
    func setupSignUpView() {
        SignUpView.layer.cornerRadius = 5.0
        SignUpView.layer.masksToBounds = true
        SignUpView.layer.borderWidth = 0.5
        SignUpView.layer.borderColor = UIColor.darkGray.cgColor
    }
    

    
    

}
