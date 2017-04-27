//
//  EventDetailsVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 3/5/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
import Firebase

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var eventPhoto: UIImageView!
    @IBOutlet weak var eventTitile: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventTimestamp: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventFees: UILabel!
    @IBOutlet weak var eventCategory: RoundButton!
    @IBOutlet weak var eventTargetAudience: UILabel!
    @IBOutlet weak var volunteerNeededFlag: UILabel!
    @IBOutlet weak var hostedByBtn: UIButton!
    
    var userPost: FIRDatabaseReference!
    var postData = Post()
    var img: UIImage? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        userPost = DataService.ds.REF_USERS.child(postData.postedBy)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        
        eventTitile.text = postData.eventCaption
        eventDesc.text = postData.eventDescription
        eventTimestamp.text = "\(postData.eventTime)-\(postData.eventDate)"
        eventLocation.text = postData.eventAddress
        eventFees.text = postData.eventFees
        eventCategory.setTitle(postData.eventCategory, for: .normal)
        eventTargetAudience.text = postData.eventAudience
        if (postData.eventVolunteersIsNeeded){
            volunteerNeededFlag.text = "True"
        }else{
            volunteerNeededFlag.text = "false"
        }
        userPost.observeSingleEvent(of: .value, with:{ (snapshot: FIRDataSnapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?.value(forKey: "firstName")
            let lastName = value?.value(forKey: "lastName")
            self.hostedByBtn.setTitle("\(firstName!) \(lastName!)", for: .normal)
            
        })
        print(postData)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //remove "back" from the cursor side in the navigation bar
        //self.navigationController?.navigationBar.backItem?.title="Back"
    }
    
    @IBAction func audienceRegLink(_ sender: Any) {
        if postData.eventAudienceRegistrationLink != "" {
            
            openLinkOnWebView(link: "\(postData.eventAudienceRegistrationLink)")
            
        }else{
            //link not provided
        }
    }
    
    @IBAction func volunteerRegLink(_ sender: Any) {
        if postData.eventVolunteersRegistrationLink != "" {
            
            openLinkOnWebView(link: "\(postData.eventVolunteersRegistrationLink)")
            
        }else{
            //link not provided
        }
    }
    
    @IBAction func facebookLink(_ sender: Any) {
        if (postData.eventFacebookPage != ""){
            //            let facebookHooks = "fb://groups/\(postData.eventFacebookPage)"
            let facebookHooks = "\(postData.eventFacebookPage)"
            
            let facebookUrl = NSURL(string: facebookHooks)
            if UIApplication.shared.canOpenURL(facebookUrl! as URL)
            {
                UIApplication.shared.open(facebookUrl! as URL)
            } else {
                openLinkOnWebView(link: "www.facebook.com/\(postData.eventFacebookPage)")
            }
            
        }else{
            //fb not provided
            print("fb not provided")
        }
    }
    
    @IBAction func twitterLink(_ sender: Any) {
        if (postData.eventTwitterPage != ""){
            let twitterHooks = "twitter://profile/\(postData.eventInstagramPage)"
            let twitterUrl = NSURL(string: twitterHooks)
            if UIApplication.shared.canOpenURL(twitterUrl! as URL)
            {
                UIApplication.shared.open(twitterUrl! as URL)
            } else {
                openLinkOnWebView(link: "www.twitter.com/\(postData.eventTwitterPage)")
            }
            
        }else{
            //twitter not provided
            print("twitter not provided")
            
        }
        
    }
    
    @IBAction func instagramLink(_ sender: Any) {
        if (postData.eventInstagramPage != ""){
            let instagramHooks = "instagram://user?username=\(postData.eventInstagramPage)"
            let instagramUrl = NSURL(string: instagramHooks)
            if UIApplication.shared.canOpenURL(instagramUrl! as URL)
            {
                UIApplication.shared.open(instagramUrl! as URL)
            } else {
                openLinkOnWebView(link: "www.instagram.com/\(postData.eventInstagramPage)")
            }
            
        }else{
            //insta not provided
            print("instagram not provided")
            
        }
        
    }
    
    @IBAction func snapchatLink(_ sender: Any) {
        alertDialogPopup(alertTitle: "SnapChat ID", alertMessage: "Snapchat username: \(postData.eventSnapchatUserName)", buttonTitle: "Got it")
    }
    
    @IBAction func hostProfile(_ sender: Any) {
        if (postData.postedByFlag){
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
            destination.postedById = "\(postData.postedBy)"
            navigationController?.pushViewController(destination, animated: true)
        }else{
           alertDialogPopup(alertTitle: "Sorry!", alertMessage: "User Information unavilable", buttonTitle: "ok")
        }
    }
    
    
    
    func loadImage(){
        if img != nil{
            self.eventPhoto.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: self.postData.eventImage)
            ref.data(withMaxSize: 15 * 1024 * 1024, completion: {(data,error) in
                if error != nil {
                    print("EventDetailsVC: Unable to download image from Firebase Storage \(String(describing: error))")
                }else{
                    print("EventDetailsVC: Image downloaded from Firebase Storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.eventPhoto.image = img
                        }
                    }
                }
            })
            
        }
    }
    
    
    
    func alertDialogPopup(alertTitle: String, alertMessage: String, buttonTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openLinkOnWebView(link: String!){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "webViewVC") as! WebViewVC
        destination.urlString = link
        navigationController?.pushViewController(destination, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
