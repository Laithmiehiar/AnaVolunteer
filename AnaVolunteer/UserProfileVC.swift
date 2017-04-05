//
//  UserProfileVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 3/30/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation
import UIKit

class UserProfileVC: UIViewController , UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var userProfileImage: CircleImageView!
    @IBOutlet weak var socialLink: UIImageView!
    
    let picker = UIImageView(image: UIImage(named: "pickerbkg2"))
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
    }
    @IBAction func PhoneTapped(_ sender: Any) {
        
    }
    @IBAction func socialLinkTapped(_ sender: Any) {
        picker.isHidden ? openPicker() : closePicker()
    }
    
    @IBAction func messageTapped(_ sender: Any) {
        
    }
    
    
    func createPicker()
    {
        picker.frame = CGRect(x: self.socialLink.frame.origin.x + 65, y: 200, width: 62, height: 144)
        picker.alpha = 0
        picker.isHidden = true
        picker.isUserInteractionEnabled = true
        
        var offset = 6
        
        for (index, social) in properties.socialLinks.enumerated()
        {
          
            let button = UIButton()
            button.frame = CGRect(x: 0, y: offset, width: 62, height: 43)
//            button.setTitleColor(UIColor(rgba: social["color"]!), for: UIControlState())
            button.setImage(UIImage.init(named: social["img"]!), for: UIControlState())
//            button.setTitle(social["title"], for: UIControlState())
            button.tag = index
            
            picker.addSubview(button)
            
            offset += 29
                
        }
        view.addSubview(picker)
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
    
    func touchBegin(_ sender:UITapGestureRecognizer){
        closePicker()
    }
}
