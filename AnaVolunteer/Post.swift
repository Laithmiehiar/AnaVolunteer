//
//  Post.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/28/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation
import Firebase
class Post{
    /*
     private var _eventCaption: String!
     private var _eventAddress: String!
     private var _eventAudience: String!
     private var _eventAudienceRegistrationLink: String!
     private var _eventCategory: String!
     private var _eventDescription: String!
     private var _eventFacebookPage: String!
     private var _eventFees: String!
     private var _eventInstagramPage: String!
     private var _eventSnapchatUserName: String!
     private var _eventTime: String!
     private var _eventTwitterPage: String!
     private var _eventVolunteersIsNeeded: String!
     private var _eventVolunteersRegistrationLink: String!
     private var _sharingHostedProfile: String!
     private var _eventDate: String!
     
     private var _category: String!
     private var _likesfromFavButton: Int!
     private var _postKey: String!
     private var _eventImage: String!
     private var _postRef: FIRDatabaseReference!
     
*/
    private var _eventCaption: String!
    private var _time: String!
    private var _postedBy: String!
    private var _location: String!
    private var _category: String!
    private var _likesfromFavButton: Int!
    private var _postKey: String!
    private var _imageUrl: String!
    private var _postRef: FIRDatabaseReference!
    
    init(eventCaption: String, time: String, postedBy: String, location: String, category: String,likesfromFavButton:Int,imageUrl: String) {
        self._eventCaption = eventCaption
        self._time = time
        self._postedBy = postedBy
        self._location = location
        self._category = category
        self._likesfromFavButton = likesfromFavButton
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
        if let likesfromFavButton = postData["likes"] as? Int{
            self._likesfromFavButton = likesfromFavButton
        }
        if let imageUrl = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    
    func adjustLikes(addLike: Bool){
        if addLike{
            _likesfromFavButton = _likesfromFavButton + 1
        }else{
            _likesfromFavButton = likesfromFavButton - 1
        }
        _postRef.child("likes").setValue(_likesfromFavButton)
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
    
    var likesfromFavButton: Int{
        return _likesfromFavButton
    }
    
    var postKey: String{
        return _postKey
    }
    
    var imageUrl: String{
        return _imageUrl
    }
    
}
