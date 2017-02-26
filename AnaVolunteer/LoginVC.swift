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
class LoginVC: UIViewController {
    
    @IBOutlet weak var email: CustomeTextFieldWithIcon!
    @IBOutlet weak var password: CustomeTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //set email-text field icon
        setLeftIcontoTextField(iconName: "mail", textFieldName: email)
        //set password-text field icon
        setLeftIcontoTextField(iconName: "pwd", textFieldName: password)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    func setLeftIcontoTextField(iconName : String , textFieldName:CustomeTextFieldWithIcon){
        let imageview = UIImageView(frame: CGRect(x:15, y: 6, width: 20, height: 20))
        let image = UIImage(named: iconName)
        imageview.image = image
        textFieldName.leftViewMode = UITextFieldViewMode.always
        //email.leftView = imageview
        textFieldName.addSubview(imageview)
    }
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
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: {(user,error) in
            if error != nil{
                print("LoginVC: Unable to authenticate with Facebook \(error)")
            }
            else{
                print("LoginVC: Successfully authenticated with Firebase")
                
            }
        })
    }
}

