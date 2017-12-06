//
//  LoginViewController.swift
//  DragonGossip
//
//  Created by David Murges on 8/9/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class LoginViewController: UIViewController {

    
    

    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var LoginView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
        setupLoginView ()
        setupLoginButton()
        setupSignUpButton()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func didLogIn(_ sender: Any) {
        
        guard let email = emailtext.text, let password = passwordText.text else {
            print("Form not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                self.showAlert()
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Wrong email or password", message: "Please enter a valid email and password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true) {
            self.passwordText.text = nil
        }
        
    }
    
    
    func setupSignUpButton() {
        SignUpButton.layer.borderWidth = 3.0
        SignUpButton.layer.borderColor = UIColor(red: 89/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1).cgColor
        
        SignUpButton.layer.cornerRadius = 5.0
        SignUpButton.layer.masksToBounds = true
    }
    
    
    func setupLoginButton() {
        LoginButton.layer.cornerRadius = 5.0
        LoginButton.layer.masksToBounds = true
    }
    
    func setupLoginView() {
        LoginView.layer.cornerRadius = 5.0
        LoginView.layer.masksToBounds = true
        LoginView.layer.borderWidth = 0.5
        LoginView.layer.borderColor = UIColor.darkGray.cgColor
    }
    

    
    
}
