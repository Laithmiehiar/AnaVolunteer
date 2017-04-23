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
    private var _eventVolunteersIsNeeded: Bool!
    private var _eventVolunteersRegistrationLink: String!
    private var _sharingHostedProfile: String!
    private var _eventDate: String!
    private var _eventImage: String!
    private var _likesfromFavButton: Int!
    private var _postKey: String!
    private var _postedBy: String!
    private var _postRef: FIRDatabaseReference!
    
    
    init() {
    
    }
    
    init(eventCaption: String, eventAddress: String,eventAudience: String, eventAudienceRegistrationLink: String,
         eventCategory: String,eventDescription: String,eventFacebookPage: String,eventFees: String, eventInstagramPage: String, eventSnapchatUserName: String, eventTime: String, eventTwitterPage: String, eventVolunteersIsNeeded: Bool,eventVolunteersRegistrationLink: String, sharingHostedProfile: String,  eventDate: String,eventImage: String,postedBy: String,location: String,likesfromFavButton:Int) {
        self._eventCaption = eventCaption
        self._eventAddress = eventAddress
        self._eventAudience = eventAudience
        self._eventAudienceRegistrationLink = eventAudienceRegistrationLink
        self._eventCategory = eventCategory
        self._eventDescription = eventDescription
        self._eventFacebookPage = eventFacebookPage
        self._eventFees = eventFees
        self._eventInstagramPage = eventInstagramPage
        self._eventSnapchatUserName = eventSnapchatUserName
        self._eventTime = eventTime
        self._eventTwitterPage = eventTwitterPage
        self._eventVolunteersIsNeeded = eventVolunteersIsNeeded
        self._eventVolunteersRegistrationLink = eventVolunteersRegistrationLink
        self._sharingHostedProfile = sharingHostedProfile
        self._eventDate = eventDate
        self._likesfromFavButton = likesfromFavButton
        self._postedBy = postedBy
        self._eventImage = eventImage
    }
    
    init(postKey: String, postData: Dictionary<String,AnyObject>) {
        self._postKey = postKey
        
        if let eventCaption  = postData["eventCaption"] as? String{
            self._eventCaption = eventCaption
        }
        if let eventAddress = postData["eventAddress"] as? String{
            self._eventAddress = eventAddress
        }
        if let eventImage = postData["eventImage"] as? String{
            self._eventImage = eventImage
        }
        if let _eventAudience = postData["eventAudience"] as? String{
            self._eventAudience = _eventAudience
        }
        if let eventAudienceRegistrationLink = postData["eventAudienceRegistrationLink"] as? String{
            self._eventAudienceRegistrationLink = eventAudienceRegistrationLink
        }
        if let eventCategory = postData["eventCategory"] as? String{
            self._eventCategory = eventCategory
        }
        if let eventDescription = postData["eventDescription"] as? String{
            self._eventDescription = eventDescription
        }
        if let eventFacebookPage = postData["eventFacebookPage"] as? String{
            self._eventFacebookPage = eventFacebookPage
        }
        if let eventFees = postData["eventFees"] as? String{
            self._eventFees = eventFees
        }
        if let eventInstagramPage = postData["eventInstagramPage"] as? String{
            self._eventInstagramPage = eventInstagramPage
        }
        if let eventSnapchatUserName = postData["eventSnapchatUserName"] as? String{
            self._eventSnapchatUserName = eventSnapchatUserName
        }
        if let eventTime = postData["eventTime"] as? String{
            self._eventTime = eventTime
        }
        if let eventTwitterPage = postData["eventTwitterPage"] as? String{
            self._eventTwitterPage = eventTwitterPage
        }
        if let eventVolunteersIsNeeded = postData["eventVolunteersIsNeeded"] as? Bool{
            self._eventVolunteersIsNeeded = eventVolunteersIsNeeded
        }
        if let eventVolunteersRegistrationLink = postData["eventVolunteersRegistrationLink"] as? String{
            self._eventVolunteersRegistrationLink = eventVolunteersRegistrationLink
        }
        if let sharingHostedProfile = postData["sharingHostedProfile"] as? String{
            self._sharingHostedProfile = sharingHostedProfile
        }
        if let eventDate = postData["eventDate"] as? String{
            self._eventDate = eventDate
        }
        if let postedBy = postData["postedBy"] as? String{
            self._postedBy = postedBy
        }
        if let likesfromFavButton = postData["likes"] as? Int{
            self._likesfromFavButton = likesfromFavButton
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
    var eventAddress: String{
        return _eventAddress
    }
    var eventImage: String{
        return _eventImage
    }
    var eventAudience: String{
        return _eventAudience
    }
    
    var eventCategory: String{
        return _eventCategory
    }
    var eventDescription: String{
        return _eventDescription
    }
    var eventAudienceRegistrationLink: String{
        return _eventAudienceRegistrationLink
    }
    var eventFacebookPage: String{
        return _eventFacebookPage
    }
    var eventFees: String{
        return _eventFees
    }
    var eventInstagramPage: String{
        return _eventInstagramPage
    }
    var eventSnapchatUserName: String{
        return _eventSnapchatUserName
    }
    var eventTime: String{
        return _eventTime
    }
    var eventTwitterPage: String{
        return _eventTwitterPage
    }
    var eventVolunteersIsNeeded: Bool{
        return _eventVolunteersIsNeeded
    }
    var eventVolunteersRegistrationLink: String{
        return _eventVolunteersRegistrationLink
    }
    var sharingHostedProfile: String{
        return _sharingHostedProfile
    }
    var eventDate: String{
        return _eventDate
    }
    var postedBy: String{
        return _postedBy
    }
    var likesfromFavButton: Int{
        return _likesfromFavButton
    }
    var postKey: String{
        return _postKey
    }
    
    
}
