//
//  ForumCreationViewController.swift
//  DragonTalk
//
//  Created by David Murges on 21/9/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import Firebase

class ForumCreationViewController: UIViewController {

    
   @IBOutlet weak var forumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    
    @IBAction func didCreate(_ sender: Any) {
        
        guard let forumTopic = forumTextField.text else {
            print("Invalid Name")
            return
        }
        
        
        
        let dataRef = FIRDatabase.database().reference(fromURL: "https://dragongossip-d45b4.firebaseio.com/").child("Forums")
        let ref = dataRef.childByAutoId()
        
        let forum = ["Title": forumTopic]
        
        
        ref.updateChildValues(forum, withCompletionBlock: { (error, dataRef) in
            
            if error != nil {
                print(error!)
                return
            }
            
            
            print("Saved succesfully")
            self.navigationController?.popViewController(animated: true)
            
        })
        
    }
    
    

}
