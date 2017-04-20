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
     var profileImageURL: String = ""
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
          
          guard !(fname.text?.isEmpty)! else{
               self.fname.shake()
               return
          }
          guard !(lname.text?.isEmpty)! else{
               self.lname.shake()
               return
          }
          guard let mail = email.text else{
               self.email.shake()
               return
          }
          guard let pwd = password.text else{
               self.password.shake()
               return
          }
          guard let confirmPwd = confirmPassword.text else{
               self.confirmPassword.shake()
               return
          }
          
          guard validateEmail(candidate: mail) else{
               //Invalid email
               message.isHidden = false
               message.text = "Invalid Email"
               self.email.shake()
               return
          }
          
          guard pwd == confirmPwd else{
               //unmatch passwords
               message.isHidden = false
               message.text = "Passwords unmatched"
               self.password.shake()
               self.confirmPassword.shake()
               return
          }
          
          guard pwd.characters.count >= 6 else{
               //password is less than 6 characters
               message.isHidden = false
               message.text = "Password should be at least 6 characters"
               self.password.shake()
               self.confirmPassword.shake()
               return
          }
          
          message.isHidden = true
          
          
          //create new account
          FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user,error) in
               if error != nil{
                    print("SignupVC: Unable to authenticated with Firebase using email \(error)")
                    self.alertDialogPopup(alertTitle: "HEY!", alertMessage: "The email address is already in use by another account!", buttonTitle: "Ok")
                    
               }else{
                    print("SignupVC: Successfully authenticated email with Firebase")
                    let userData: Dictionary<String,String> = ["provider:": user!.providerID,
                                                               "firstName": (self.fname?.text)!,
                                                               "lastName": (self.lname?.text)!,
                                                               "email": mail,
                                                               "password":pwd,
                                                               "profileImage": self.profileImageURL]
                    //check if the user select an image and upload it
                    if let userImg = self.profileImage.image{
                         
                         if let imgData = UIImageJPEGRepresentation(userImg, 2.0){
                              let imgUId = NSUUID().uuidString
                              let metadata = FIRStorageMetadata()
                              metadata.contentType = "image/jpeg"
                              
                              DataService.ds.REF_POSTS_IMAGES.child(imgUId).put(imgData, metadata: metadata){ (metadata,error) in
                                   if error != nil{
                                        print("SignupVC: Unable to upload image to firebase storage \(error)")
                                        
                                   }else{
                                        print("SignupVC: Successfully uploaded image to firebase storage")
                                        let downloadURL = metadata?.downloadURL()?.absoluteString
                                        self.profileImageURL = downloadURL!
                                        
                                   }
                              }
                         }
                         
                         
                    }else{
                         print("SignupVC: No Image Selected")
                         return
                    }
                    //add user info into the DB
                    self.completeSignin(userId: user!.uid,userData: userData)
               }
          })
          
          
          
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
               alertDialogPopup(alertTitle: "Warning!", alertMessage: "Invalid image was selected", buttonTitle: "Ok")
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
     
     func alertDialogPopup(alertTitle: String, alertMessage: String, buttonTitle: String){
          let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
          alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
     }
     
}
