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
    
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImg.contentMode = .scaleToFill
    }
    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.eventName.text = post.eventCaption
        self.timeEvent.text = post.time
        self.location.text = post.location
        self.likesNo.text = ("\(post.likes)")
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
    }
    
    
    
    
    
    
}
