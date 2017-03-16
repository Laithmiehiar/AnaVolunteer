//
//  ShareAnEventVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 3/3/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
import Firebase
import UITextField_Shake
//import DataService
class ShareAnEventVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scollview: UIScrollView!
    @IBOutlet weak var eventImage: CircleImageView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventDateTime: UIDatePicker!
    @IBOutlet weak var eventAddress: UITextField!
    @IBOutlet weak var eventFees: UITextField!
    @IBOutlet weak var eventCategory: UIPickerView!
    @IBOutlet weak var eventAudience: UITextField!
    @IBOutlet weak var eventAudienceRegistrationLink: UITextField!
    @IBOutlet weak var eventVolunteersIfNeeded: UISegmentedControl!
    @IBOutlet weak var eventVolunteersRegistrationLink: UITextField!
    @IBOutlet weak var eventFacebookPage: UITextField!
    @IBOutlet weak var eventTwitterPage: UITextField!
    @IBOutlet weak var eventInstagramPage: UITextField!
    @IBOutlet weak var eventSnapchatId: UITextField!
    @IBOutlet weak var sharingHostedProfile: UISegmentedControl!
    
    
    var imagePicker : UIImagePickerController!
    var eventImageURL: String = ""
    var imageSelected: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the keyboard whereever tapped around
        self.hideKeyboardWhenTappedAround()
        
        //pick an image for the event
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func eventImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            eventImage.image = image
            imageSelected = true;
        }else{
            alertDialogPopup(alertTitle: "Warning!", alertMessage: "Invalid image was selected", buttonTitle: "Ok")
            print("ShareAnEventVC: Invalid image was selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        guard !(eventName.text?.isEmpty)! else {
            self.eventName.shake()
            return
        }
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        timeFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: eventDateTime.date)
        let strTime = timeFormatter.string(from: eventDateTime.date)
        print(strDate)
        print(strTime)
        
        //check if the user select an image and upload it
        if let userImg = self.eventImage.image{
            
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
                        if let url = downloadURL{
                            //self.profileImageURL = downloadURL!
                            self.postToFirebase(imageURL: url, eventTime: strTime, eventDate: strDate)
                        }
                    }
                }
            }
            
            
        }else{
            print("SignupVC: No Image Selected")
            return
        }

    }
    
    func postToFirebase(imageURL: String, eventTime: String, eventDate: String){
        let post: Dictionary<String,Any> = [
            "eventImage":imageURL,
            "eventName": eventName.text!,
            "eventDescription": eventDescription.text ?? "No Desctription",
            "eventTime": eventTime,
            "eventDate":eventDate,
            "eventAddress": eventAddress.text,
            "eventFees": eventFees.text,
            "eventCategory": eventCategory,
            "eventAudience": eventAudience.text,
            "eventAudienceRegistrationLink": eventAudienceRegistrationLink.text,
            "eventVolunteersIsNeeded": eventVolunteersIfNeeded,
            "eventVolunteersRegistrationLink": eventVolunteersRegistrationLink,
            "eventFacebookPage": eventFacebookPage,
            "eventTwitterPage": eventTwitterPage,
            "eventInstagramPage": eventInstagramPage,
            "eventSnapchatUserName": eventSnapchatId,
            "sharingHostedProfile": sharingHostedProfile]
        
            let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
            firebasePost.setValue(post)
        
                
        
    }
    
    func alertDialogPopup(alertTitle: String, alertMessage: String, buttonTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
