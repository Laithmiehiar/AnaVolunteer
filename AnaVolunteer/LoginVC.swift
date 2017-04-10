//
//  ViewController.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/24/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: CustomeTextFieldWithIcon!
    @IBOutlet weak var passwordField: CustomeTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set email-text field icon
        setLeftIcontoTextField(iconName: "mail", textFieldName: emailField)
        //set password-text field icon
        setLeftIcontoTextField(iconName: "pwd", textFieldName: passwordField)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_ID){
            print("LoginVC: ID found in keychain")
            performSegue(withIdentifier: "goToHomePage", sender: nil)
        }
        
    }
    
    func setLeftIcontoTextField(iconName : String , textFieldName:CustomeTextFieldWithIcon){
        let imageview = UIImageView(frame: CGRect(x:15, y: 6, width: 20, height: 20))
        let image = UIImage(named: iconName)
        imageview.image = image
        textFieldName.leftViewMode = UITextFieldViewMode.always
        //email.leftView = imageview
        textFieldName.addSubview(imageview)
    }
    
    // Signin using Facebook
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            if error != nil{
                print("LoginVC: Unable to authenticate with Facebook - \(error)")
            }else if result?.isCancelled == true{
                print("LoginVC: User canceled Facebook authentication")
            }else{
                print("LoginVC: Successfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    //check if the user has a record after bring the info from the facebook
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: {(user,error) in
            if error != nil{
                print("LoginVC: Unable to authenticate with Facebook \(error)")
            }
            else{
                print("LoginVC: Successfully authenticated with Firebase")
                if let user = user{
                    let userData = ["provider": credential.provider]
                    self.completeSignin(userId: user.uid,userData: userData)
                }
            }
        })
    }
    
    //SignIn using an email and password
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user,error)in
                if error == nil{
                    print("LoginVC: Email user authenticated with Firebase")
                    if let user = user{
                        let userData = ["provider": user.providerID]
                        self.completeSignin(userId: user.uid,userData: userData)
                    }
                }
                else{
                    self.alertDialogPopup(alertTitle: "Warning!", alertMessage: "please recheck your email or passwor", buttonTitle: "Ok")
                    print("LoginVC: authentication failed with Firebase, please recheck your email or password \(error)")
                }
            })
        }
    }
    
    //store the credintial into the keychain
    func completeSignin(userId: String, userData: Dictionary<String,String>){
        DataService.ds.createFirebaseDBUser(uid: userId, userData: userData)
        let keychainResult =  KeychainWrapper.standard.set(userId, forKey: KEY_ID)
        print("LoginVC: data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToHomePage", sender: nil)
        
    }
    
    func alertDialogPopup(alertTitle: String, alertMessage: String, buttonTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
