//
//  CircleImageView.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/27/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView{
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
