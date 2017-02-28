//
//  SignupVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/25/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

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
     
     @IBAction func createAccountTapped(_ sender: Any) {
          if fname.text != nil && lname.text != nil && email.text != nil && password.text != nil && confirmPassword.text != nil{
               if (password.text == confirmPassword.text){
                    //create new account
                    FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user,error) in
                         if error != nil{
                              print("LoginVC: Unable to authenticated with Firebase using email")
                         }else{
                              print("LoginVC: Successfully authenticated email with Firebase")
                              let userData = ["provider:": user!.providerID]
                              self.completeSignin(userId: user!.uid,userData: userData)
                         }
                    })
                    
               }else{
                    //unmatch passwords
                    
               }
          }else{
               //empty field is exist
          }
     }
     
     
     //store the credintial into the keychain
     func completeSignin(userId: String, userData: Dictionary<String,String>){
          DataService.ds.createFirebaseDBUser(uid: userId, userData: userData)
          let keychainResult =  KeychainWrapper.standard.set(userId, forKey: KEY_ID)
          print("LoginVC: data saved to keychain \(keychainResult)")
          performSegue(withIdentifier: "goToHomePage", sender: nil)
          
     }
     
}
