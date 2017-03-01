//
//  Post.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/28/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation

class Post{
    private var _eventCaption: String!
    private var _time: String!
    private var _postedBy: String!
    private var _location: String!
    private var _category: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _imageUrl: String!
    init(eventCaption: String, time: String, postedBy: String, location: String, category: String,likes:Int,imageUrl: String) {
        self._eventCaption = eventCaption
        self._time = time
        self._postedBy = postedBy
        self._location = location
        self._category = category
        self._likes = likes
        self._imageUrl = imageUrl
    }
    
    init(postKey: String, postData: Dictionary<String,AnyObject>) {
        self._postKey = postKey
        
        if let eventCaption  = postData["eventCaption"] as? String{
            self._eventCaption = eventCaption
        }
        if let time = postData["time"] as? String{
            self._time = time
        }
        if let postedBy = postData["postedBy"] as? String{
            self._postedBy = postedBy
        }
        if let location = postData["location"] as? String{
            self._location = location
        }
        if let category = postData["category"] as? String{
            self._category = category
        }
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
       
        
    }
    var eventCaption: String{
        return _eventCaption
    }
    
    var time: String{
        return _time
    }
    
    var postedBy: String{
        return _postedBy
    }
    
    var location: String{
        return _location
    }
    
    var category: String{
        return _category
    }
    
    var likes: Int{
        return _likes
    }
    
    var postKey: String{
        return _postKey
    }
    
    var imageUrl: String{
        return _imageUrl
    }
    
}
