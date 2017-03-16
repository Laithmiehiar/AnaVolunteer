//
//  PostCell.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/26/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
import Firebase
class PostCell: UITableViewCell {
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var timeEvent: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var likesNo: UILabel!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var favImg: UIImageView!
    
    var post: Post!
    var favsRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImg.contentMode = .scaleToFill
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(favBtnTapped))
        tap.numberOfTapsRequired = 1
        favImg.addGestureRecognizer(tap)
        favImg.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        favsRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.eventName.text = post.eventCaption
        self.timeEvent.text = post.time
        self.location.text = post.location
        self.likesNo.text = ("\(post.likesfromFavButton)")
        self.postedBy.text = post.postedBy
        self.category.setTitle(post.category, for: .normal)
        
        if img != nil{
            self.postImg.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 15 * 1024 * 1024, completion: {(data,error) in
                if error != nil {
                    print("PostCell: Unable to download image from Firebase Storage \(error)")
                }else{
                    print("PostCell: Image downloaded from Firebase Storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImg.image = img
                            HomePageVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                            
                        }
                    }
                }
            })
        }
        
        favsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.favImg.image = UIImage(named: "addfav2-1")
            }else{
                self.favImg.image = UIImage(named: "delfav223")
                
            }
            
        })
    }
    
    
    
    func favBtnTapped(sender: UITapGestureRecognizer) {
        favsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.favImg.image = UIImage(named: "addfav2-1")
                self.post.adjustLikes(addLike: true)
                self.favsRef.setValue(true)
            }else{
                self.favImg.image = UIImage(named: "delfav223")
                self.post.adjustLikes(addLike: false)
                self.favsRef.removeValue()
            }
            
        })
    }
    
    
}
