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
import SwiftKeychainWrapper
//import DataService
class ShareAnEventVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    var volunteerIsNeeded: Bool = false
    var shareProfile: Bool = false
    var eventTypes = [String]()
    var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the keyboard whereever tapped around
        self.hideKeyboardWhenTappedAround()
        
        //pick an image for the event
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        //UIPicker view
        self.eventCategory.dataSource = self
        self.eventCategory.delegate = self
        //get Events Categories
        getEventTypes()
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
            alertDialogPopup(alertTitle: "Warning", alertMessage: "No Image Selected", buttonTitle: "Ok")
            return
        }
        
    }
    
    func postToFirebase(imageURL: String, eventTime: String, eventDate: String){
        var post: Dictionary<String,Any>= [:];
        do {
            post.updateValue(imageURL, forKey: "eventImage")
            post.updateValue(eventName.text!, forKey: "eventCaption")
            post.updateValue(eventDescription.text, forKey: "eventDescription")
            post.updateValue(eventTime, forKey: "eventTime")
            post.updateValue(eventDate, forKey: "eventDate")
            post.updateValue(eventAddress.text ?? "Not Provided", forKey: "eventAddress")
            post.updateValue(eventFees.text ?? "Not Provided", forKey: "eventFees")
            post.updateValue(selectedCategory, forKey: "eventCategory")
            post.updateValue(eventAudience.text ?? "Public,", forKey: "eventAudience")
            post.updateValue(eventAudienceRegistrationLink.text ?? "Not Provided", forKey: "eventAudienceRegistrationLink")
            post.updateValue(volunteerIsNeeded, forKey: "eventVolunteersIsNeeded")
            post.updateValue(eventVolunteersRegistrationLink.text ?? "Not Provided", forKey: "eventVolunteersRegistrationLink")
            post.updateValue(eventFacebookPage.text ?? "Not Provided", forKey: "eventFacebookPage")
            post.updateValue(eventTwitterPage.text ?? "Not Provided", forKey: "eventTwitterPage")
            post.updateValue(eventInstagramPage.text ?? "Not Provided", forKey: "eventInstagramPage")
            post.updateValue( eventSnapchatId.text ?? "Not Provided", forKey: "eventSnapchatUserName")
            post.updateValue( 0, forKey: "likes")
            post.updateValue( eventSnapchatId.text ?? "Not Provided", forKey: "eventSnapchatUserName")
            post.updateValue(KeychainWrapper.standard.string(forKey: KEY_ID) ?? 0, forKey: "postedBy")

            
        }catch let error as NSError {
            print(error)
        }
       
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        
        performSegue(withIdentifier: "showHome", sender: nil)
    }
    
    func alertDialogPopup(alertTitle: String, alertMessage: String, buttonTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func volunteerNeeded(_ sender: Any) {
        switch eventVolunteersIfNeeded.selectedSegmentIndex
        {
        case 0:
            volunteerIsNeeded = false;
        case 1:
            volunteerIsNeeded = true;
        default:
            break;
        }
    }
    
    @IBAction func shareProfileSeg(_ sender: Any) {
        switch sharingHostedProfile.selectedSegmentIndex
        {
        case 0:
            shareProfile = false;
        case 1:
            shareProfile = true;
        default:
            break;
        }
    }
    
    func getEventTypes(){
        self.eventTypes.removeAll()
        DataService.ds.REF_CATEGORIES.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    print ("SNAP: \(snap)")
                    if (snap.value as? String) != nil{
                        let key = snap.key
                        let value = snap.value
                        if !(self.eventTypes.contains(key)){
                            self.eventTypes.append(value as! String)
                            
                        }
                    }
                }
            }
            self.eventCategory.reloadAllComponents()
        })
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventTypes.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = eventTypes[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 12) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = eventTypes[row]
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
