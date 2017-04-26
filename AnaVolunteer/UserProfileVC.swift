//
//  UserProfileVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 3/30/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import Firebase
import Elissa
import MessageUI
class UserProfileVC: UIViewController , UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var aboutTextView: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var socialLink: UIImageView!
    
    
    
    let picker = UIImageView(image: UIImage(named: "pickerbkg2"))
    var userData = User()
    
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
    
    
    struct properties {
        static let socialLinks = [
            ["title" : "Facebook", "color" : "#3b5998", "img" : "facebook.png"],
            ["title" : "Twitter", "color": "#55acee", "img" : "twitter.png"],
            ["title" : "Instagram", "color" : "#125688", "img" : "instagram.png"],
            ["title" : "Snapchat", "color" : "#fffc00", "img" : "snapchat.png"]
        ]
    }
    
    
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        //load social picker
        createPicker()
        
        //dismiss the picker popUp
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.touchBegin (_:)))
        self.view.addGestureRecognizer(gesture)
        
        if let userId = KeychainWrapper.standard.string(forKey: KEY_ID){
            print("UserProfileVC: ID found in keychain  \(userId)")
            loadUserData(userId: userId)
        }
        
        
        
    }
    @IBAction func PhoneTapped(_ sender: Any) {
        if userData.phoneNumber != "" {
            if let url = NSURL(string: "telprompt://\(userData.phoneNumber)"), UIApplication.shared.canOpenURL(url as URL){
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }else{
            alertDialogPopup(alertTitle: "Sorry!", alertMessage: "This user hasn't provided Phone Number", buttonTitle: "Ok")
        }
    }
    
    @IBAction func MessageTapped(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail(){
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.userData.email])
            mail.setSubject("")
            mail.setMessageBody("Using Ana Volunteer App.", isHTML: true)
            
            present(mail, animated: true)
        }else{
            //the device not able to send an email
            alertDialogPopup(alertTitle: "Sorry!", alertMessage: "error occured", buttonTitle: "Ok")
            
        }
    }
    
    @IBAction func SocialTapped(_ sender: Any) {
        print("socialtapped");
        picker.isHidden ? openPicker() : closePicker()
    }
    
    @IBOutlet var heartTapped: UITapGestureRecognizer!
    
    
    
    func loadUserData(userId: String) {
        DataService.ds.REF_USERS.child(userId).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    print ("SNAP: \(snap)")
                    if(snap.key != "likes"){
                        if snap.value != nil && snap.value as! String != ""{
                            let key = snap.key
                            switch key{
                            case "email":
                                self.aboutTextView.text = snap.value as! String!
                                self.userData.email = snap.value as! String!
                                break
                            case "firstName":
                                self.userData.firstName = snap.value as! String!
                                break
                            case "lastName":
                                self.userData.lastName = snap.value as! String!
                                
                                self.userNameLabel.text = "\(self.userData.firstName) \(self.userData.lastName)"
                                break
                            case "password":
                                
                                self.userData.password = snap.value as! String!
                                break
                            case "profileImage":
                                
                                self.userData.profileImage = snap.value as! String!
                                
                                if let img = UserProfileVC.imageCache.object(forKey: self.userData.profileImage as NSString){
                                    self.userProfileImage.image = img
                                }else {
                                    let ref = FIRStorage.storage().reference(forURL: self.userData.profileImage)
                                    ref.data(withMaxSize: 15 * 1024 * 1024, completion: {(data,error) in
                                        if error != nil {
                                            print("UserProfileVC: Unable to download image from Firebase Storage \(error)")
                                        }else{
                                            print("UserProfileVC: Image downloaded from Firebase Storage")
                                            if let imgData = data{
                                                if let img = UIImage(data: imgData){
                                                    self.userProfileImage.image = img
                                                    UserProfileVC.imageCache.setObject(img, forKey: self.userData.profileImage as NSString)
                                                    
                                                }
                                            }
                                        }
                                    })
                                    
                                }
                                
                                break
                            case "provider":
                                
                                self.userData.provider = snap.value as! String!
                                break
                            case "phoneNumber":
                                
                                self.userData.phoneNumber = snap.value as! String!
                                break
                            default:
                                print("default")
                                break
                            }
                            
                        }
                    }
                }
            }
            
        })
        
    }
    
    func createPicker()
    {
        picker.frame = CGRect(x: self.socialLink.frame.origin.x + 65, y: 200, width: 62, height: 144)
        picker.alpha = 0
        picker.isHidden = true
        picker.isUserInteractionEnabled = true
        
        var offset = 3
        
        for (index, social) in properties.socialLinks.enumerated()
        {
            
            let button = UIButton()
            button.frame = CGRect(x: 0, y: offset, width: 62, height: 43)
            //            button.setTitleColor(UIColor(rgba: social["color"]!), for: UIControlState())
            button.setImage(UIImage.init(named: social["img"]!), for: UIControlState())
            //            button.setTitle(social["title"], for: UIControlState())
            button.tag = index
            
            picker.addSubview(button)
            
            offset += 31
            
            button.addTarget(self, action: #selector(UserProfileVC.buttonTapped), for: .touchUpInside)
            
        }
        view.addSubview(picker)
    }
    
    func buttonTapped(sender: UIButton) {
        print(sender.tag)
        switch sender.tag{
        case 0:
            if userData.facebookLink != ""{
                let facebookHooks = "fb://profile/\(userData.facebookLink)"
                let facebookUrl = NSURL(string: facebookHooks)
                if UIApplication.shared.canOpenURL(facebookUrl! as URL)
                {
                    UIApplication.shared.open(facebookUrl! as URL)
                    
                } else {
                    //redirect to safari because the user doesn't have facebook
                    UIApplication.shared.open(NSURL(string: "http://facebook.com/\(userData.facebookLink)")! as URL)
                }
            }else{
                alertDialogPopup(alertTitle: "Sorry!", alertMessage: "This user hasn't provided the Facebook link", buttonTitle: "Ok")
            }
            break
        case 1:
            if userData.twitterLink != ""{
            }else{
                alertDialogPopup(alertTitle: "Sorry!", alertMessage: "This user hasn't provided the Twitter link", buttonTitle: "Ok")
            }
            break
        case 2:
            if userData.instagramLink != ""{
                let instagramHooks = "instagram://user?username=johndoe"
                let instagramUrl = NSURL(string: instagramHooks)
                if UIApplication.shared.canOpenURL(instagramUrl! as URL)
                {
                    UIApplication.shared.open(instagramUrl! as URL)
                    
                } else {
                    //redirect to safari because the user doesn't have Instagram
                    UIApplication.shared.open(NSURL(string: "http://instagram.com/")! as URL)
                }
            }else{
                alertDialogPopup(alertTitle: "Sorry!", alertMessage: "This user hasn't provided the Instagram link", buttonTitle: "Ok")
            }
            
            break
        case 3:
            if userData.snapChatLink != ""{
            }else{
                alertDialogPopup(alertTitle: "Sorry!", alertMessage: "This user hasn't provided the SnapChat code", buttonTitle: "Ok")
            }
            break
        default:
            break
        }
    }
    func openPicker()
    {
        self.picker.isHidden = false
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.picker.frame = CGRect(x: self.socialLink.frame.origin.x + 65, y: 230, width: 62, height: 144)
                        self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.picker.frame = CGRect(x: self.socialLink.frame.origin.x + 65, y: 200, width: 62, height: 144)
                        self.picker.alpha = 0
        },
                       completion: { finished in
                        self.picker.isHidden = true
        }
        )
    }
    
    func alertDialogPopup(alertTitle: String, alertMessage: String, buttonTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func touchBegin(_ sender:UITapGestureRecognizer){
        closePicker()
        Elissa.dismiss()
    }
}
