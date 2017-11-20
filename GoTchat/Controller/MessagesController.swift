//
//  MessagesController.swift
//  DragonTalk
//
//  Created by David Murges on 26/9/17.
//  Copyright © 2017 David Murges. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var forum: Forum? {
        didSet {
            navigationItem.title = forum?.Title
            
            loadMessages()
        }
    }
    
    
    var messages = [Message]()
    let cellId = "cellId"
    let headerCellId = "headerCellId"
    var user: User?
    
    
    let topicLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 114/255, green: 1/255, blue: 1/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        return button
    }()
    
    let inputTextField: UITextField = {
       let input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.placeholder = "Write a comment..."
        return input
    }()
    
    let separatorLine: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "imageIcon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        
        containerView.addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        containerView.addSubview(self.sendButton)
        self.sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        containerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        
        containerView.addSubview(self.separatorLine)
        self.separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        self.separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        self.separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        
        return containerView
    }()
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageHeaderCell.self, forCellWithReuseIdentifier: headerCellId)
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive
        getCurrentUser()
        createGradientColor()
        setupKeyboardObservers()

    }
    
    func getCurrentUser() {
        let currentUser = FIRAuth.auth()?.currentUser?.uid
        
        let userRef = FIRDatabase.database().reference().child("users").child(currentUser!)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            let tmpUser = User()
            tmpUser.setValuesForKeys(dictionary)
            self.user = tmpUser
            
            
        }, withCancel: nil)
    }
    
    func handleUploadTap() {
        
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorage(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
        
        
    }
    
    private func uploadToFirebaseStorage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendImage(imageUrl: imageUrl, image: image)
                }
                
            })
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {

            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = NSIndexPath(item: messages.count - 1, section: 1)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShow (notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        
        
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!){
            self.view.layoutIfNeeded()
        }
    }

    
    
    func createGradientColor () {
        
        let gradientLayer = CAGradientLayer()
        let redColor = UIColor(red: 163/255, green: 34/255, blue: 34/255, alpha: 1)
        let blackColor = UIColor(red: 114/255, green: 1/255, blue: 1/255, alpha: 1)
        gradientLayer.colors = [redColor.cgColor, blackColor.cgColor]
        gradientLayer.frame = (collectionView?.frame)!
        
        view.layer.insertSublayer(gradientLayer, below: collectionView?.layer)
        
    }
    
    
    func loadMessages () {
        let forumId = forum?.id
        let messagesRef = FIRDatabase.database().reference().child("forum-messages").child(forumId!)
        
        messagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 1)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
                
            }, withCancel: nil)
            
            
            
        }, withCancel: nil)
    }
    
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
            
            if let profileImageUrl = self.user?.profileImageUrl {
                cell.profileImageView.loadImageUsingCache(urlString: profileImageUrl)
            }
            
            if message.imageUrl != nil {
                cell.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
            
            if let messageImageUrl = message.imageUrl {
                cell.messageImageView.loadImageUsingCache(urlString: messageImageUrl)
                cell.messageImageView.isHidden = false
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
    
    
    func estimateFrameForText(text: String) -> CGRect {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let size = CGSize(width: screenWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    var containerViewBottomAnchor: NSLayoutConstraint?

    
    func sendMessage() {
        let forumId = forum?.id
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromUserId = FIRAuth.auth()?.currentUser?.uid
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["message": inputTextField.text!, "fromUserId": fromUserId!,"toForumId": forumId!, "timestamp": timestamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error!)
                return
            }
            self.inputTextField.text = nil
            
            let forumMessagesRef = FIRDatabase.database().reference().child("forum-messages").child(forumId!)
            
            let messageId = childRef.key
            forumMessagesRef.updateChildValues([messageId: 1])
            
        }
        
    }
    
    private func sendImage(imageUrl: String, image: UIImage) {
        let forumId = forum?.id
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let fromUserId = FIRAuth.auth()?.currentUser?.uid
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        let values = ["imageUrl": imageUrl, "fromUserId": fromUserId!,"toForumId": forumId!, "timestamp": timestamp, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error!)
                return
            }
            self.inputTextField.text = nil
            
            let forumMessagesRef = FIRDatabase.database().reference().child("forum-messages").child(forumId!)
            
            let messageId = childRef.key
            forumMessagesRef.updateChildValues([messageId: 1])
            
        }
    }
    
    
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    func performZoom(_ startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
            }, completion: {(completed) in
                
            })
        }
    }
    
    func handleZoomOut (_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                
            })
        }
    }
}
