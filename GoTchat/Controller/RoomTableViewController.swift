//
//  RoomTableViewController.swift
//  DragonTalk
//
//  Created by David Murges on 13/9/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import Firebase

class RoomTableViewController: UITableViewController {
    

    
    var forums = [Forum]()
    var filteredForums = [Forum]()
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.register(ForumCell.self, forCellReuseIdentifier: "ForumCell")
        checkIfUserIsLoggedIn()
        fetchForums()
        loadMessages()
        
        
    }


    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forums.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let forum = self.forums[indexPath.row]
        let messageController = MessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        
        messageController.forum = forum
        self.navigationController?.pushViewController(messageController, animated: true)
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForumCell", for: indexPath) as! ForumCell
        
        
        let forum = forums[indexPath.row]
        
//
//        let message = messages[indexPath.row]
//        cell.message = message
        
        cell.forum = forum
        
        
        
        
        
        return cell
    }
    
    func loadMessages () {
        
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                
                if let toForumId = message.toForumId {
                    self.messagesDictionary[toForumId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (mess1, mess2) -> Bool in
                        return (mess1.timestamp?.intValue)! > (mess2.timestamp?.intValue)!
                    })
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
    
    func fetchForums () {
        
        FIRDatabase.database().reference().child("Forums").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let forum = Forum()
                forum.id = snapshot.key
                
                forum.setValuesForKeys(dictionary)
                self.forums.append(forum)
                self.forums.reverse()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
            
            
        }, withCancel: nil)
        
    }
    
    
    
    
    func checkIfUserIsLoggedIn () {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            logout()
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
            }, withCancel: nil)
        }
        
    }
    
    
    @IBAction func didLogout(_ sender: Any) {
        logout()
    }
    
    
    func logout () {
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        
        let secondController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(secondController!, animated: true, completion: nil)
    }
    
    
    
}
    


