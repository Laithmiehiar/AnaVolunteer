//
//  PostCell.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/26/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var timeEvent: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var likesNo: UILabel!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var category: UIButton!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImg.contentMode = .scaleToFill
    }

   
    
    

}
