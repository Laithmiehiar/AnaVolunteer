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
    var postData = Post()
    var img: UIImage? = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
            loadImage()
        
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
        print(postData)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 320, height: 1280);
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //remove "back" from the cursor side in the navigation bar
        //        self.navigationController?.navigationBar.backItem?.title="Back"
    }
    
    @IBAction func audienceRegLink(_ sender: Any) {
    }
    
    @IBAction func volunteerRegLink(_ sender: Any) {
    }
    
    @IBAction func facebookLink(_ sender: Any) {
    }
    
    @IBAction func twitterLink(_ sender: Any) {
    }
    
    @IBAction func instagramLink(_ sender: Any) {
    }
    
    @IBAction func snapchatLink(_ sender: Any) {
    }
    
    @IBAction func hostProfile(_ sender: Any) {
    }
    
    func loadImage(){
        if img != nil{
            self.eventPhoto.image = img
        }else{
                let ref = FIRStorage.storage().reference(forURL: self.postData.eventImage)
                ref.data(withMaxSize: 15 * 1024 * 1024, completion: {(data,error) in
                    if error != nil {
                        print("EventDetailsVC: Unable to download image from Firebase Storage \(error)")
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
