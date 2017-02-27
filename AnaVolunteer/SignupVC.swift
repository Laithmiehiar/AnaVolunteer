//
//  SignupVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/25/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
   
    @IBOutlet weak var fname: CustomTextField!
    @IBOutlet weak var lname: CustomTextField!
    @IBOutlet weak var email: CustomeTextFieldWithIcon!
    @IBOutlet weak var password: CustomeTextFieldWithIcon!
    @IBOutlet weak var confirmPassword: CustomeTextFieldWithIcon!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadImage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove "back" from the cursor side in the navigation bar
      self.navigationController?.navigationBar.backItem?.title=""
      self.hideKeyboardWhenTappedAround()

     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          //set email-text field icon
          setLeftIcontoTextField(iconName: "mail", textFieldName: email)
          //set password-text field icon
          setLeftIcontoTextField(iconName: "pwd", textFieldName: password)
          setLeftIcontoTextField(iconName: "pwd", textFieldName: confirmPassword)
    }
     func setLeftIcontoTextField(iconName : String , textFieldName:CustomeTextFieldWithIcon){
          let imageview = UIImageView(frame: CGRect(x:15, y: 10, width: 20, height: 20))
          let image = UIImage(named: iconName)
          imageview.image = image
          textFieldName.leftViewMode = UITextFieldViewMode.always
          //email.leftView = imageview
          textFieldName.addSubview(imageview)
     }
    


}
