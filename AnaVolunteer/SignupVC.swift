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
import UITextField_Shake

class SignupVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
     
     @IBOutlet weak var fname: CustomTextField!
     @IBOutlet weak var lname: CustomTextField!
     @IBOutlet weak var email: CustomeTextFieldWithIcon!
     @IBOutlet weak var password: CustomeTextFieldWithIcon!
     @IBOutlet weak var confirmPassword: CustomeTextFieldWithIcon!
     @IBOutlet weak var createAccountBtn: UIButton!
     @IBOutlet weak var profileImage: UIImageView!
     @IBOutlet weak var message: UILabel!
     
     
     var imagePicker: UIImagePickerController!

     override func viewDidLoad() {
          super.viewDidLoad()
          //remove "back" from the cursor side in the navigation bar
          self.navigationController?.navigationBar.backItem?.title=""
          self.hideKeyboardWhenTappedAround()
          self.email.keyboardType = UIKeyboardType.emailAddress
          
          //pick an image
          imagePicker = UIImagePickerController()
          imagePicker.allowsEditing = true
          imagePicker.delegate = self
          
          
          
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
          if (fname.text?.isEmpty)! || (lname.text?.isEmpty)! || (email.text?.isEmpty)! || (password.text?.isEmpty)! || (confirmPassword.text?.isEmpty)!{
               //empty field is exist
               if (fname.text?.isEmpty)!{
                    self.fname.shake()
               }else if (lname.text?.isEmpty)!{
                    self.lname.shake()
               }else if (email.text?.isEmpty)!{
                    self.email.shake()
               }
               else if  (password.text?.isEmpty)!{
                    self.password.shake()
               }
               else if (confirmPassword.text?.isEmpty)!{
                    self.confirmPassword.shake()
               }
          }else{
               if validateEmail(candidate: email.text!){
                    if (password.text == confirmPassword.text){
                         if((password.text?.characters.count)! >= 6){
                         message.isHidden = true
                         //create new account
                         FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user,error) in
                              if error != nil{
                                   print("SignupVC: Unable to authenticated with Firebase using email \(error)")
                              }else{
                                   print("SignupVC: Successfully authenticated email with Firebase")
                                   let userData = ["provider:": user!.providerID]
                                   self.completeSignin(userId: user!.uid,userData: userData)
                              }
                         })
                         }else{
                              message.isHidden = false
                              message.text = "Password should be at least 6 characters"
                              self.password.shake()
                              self.confirmPassword.shake()
                         }
                    }else{
                         //unmatch passwords
                         message.isHidden = false
                         message.text = "Passwords unmatched"
                         self.password.shake()
                         self.confirmPassword.shake()
                    }
                    
               }else{
                    //Invalid email
                    message.isHidden = false
                    message.text = "Invalid Email"
                    self.email.shake()
               }
          }
     }
  
     
     //store the credintial into the keychain
     func completeSignin(userId: String, userData: Dictionary<String,String>){
          DataService.ds.createFirebaseDBUser(uid: userId, userData: userData)
          let keychainResult =  KeychainWrapper.standard.set(userId, forKey: KEY_ID)
          print("SignupVC: data saved to keychain \(keychainResult)")
          performSegue(withIdentifier: "goToHomePage2", sender: nil)
          
     }
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
          if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
               profileImage.image = image
          }else{
               print("SignupVC: Invalid image was selected")
          }
          imagePicker.dismiss(animated: true, completion: nil)
     }
     
     @IBAction func addImageTapped(_ sender: Any) {
          present(imagePicker, animated: true, completion: nil)
     }
     
     
     func validateEmail(candidate: String) -> Bool {
          let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
          return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
     }
     
}
