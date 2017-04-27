//
//  User.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 4/5/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation
import Firebase

class User{
    private var _firstName: String!
    private var _lastName: String!
    private var _email: String!
    private var _profileImage: String!
    private var _provider: String!
    private var _about: String!
    private var _password: String!
    private var _phoneNumber: String!
    private var _facebookLink: String!
    private var _twitterLink: String!
    private var _instagramLink: String!
    private var _snapChatLink: String!
    private var _userKey: String!
    private var _userRef: FIRDatabaseReference!
    
    init(){
        
    }
    init(userKey: String, userData: Dictionary<String,AnyObject>) {
        self._userKey = userKey
        
        if let firstName  = userData["first_name"] as? String{
            self._firstName = firstName
        }
        if let lastName = userData["last_name"] as? String{
            self._lastName = lastName
        }
        if let password = userData["password"] as? String{
            self._password = password
        }
        if let email = userData["email"] as? String{
            self._email = email
        }
        if let profileImage = userData["profileImage"] as? String{
            self._profileImage = profileImage
        }
        if let provider = userData["provider:"] as? String{
            self._provider = provider
        }
        if let about = userData["about"] as? String{
            self._about = about
        }
        if let phoneNumber = userData["phoneNumber"] as? String{
            self._phoneNumber = phoneNumber
        }
        if let facebookLink = userData["facebookLink"] as? String{
            self._facebookLink = facebookLink
        }
        if let twitterLink = userData["twitterLink"] as? String{
            self._twitterLink = twitterLink
        }
        if let instagramLink = userData["instagramLink"] as? String{
            self._instagramLink = instagramLink
        }
        if let snapChatLink = userData["snapCharLink"] as? String{
            self._snapChatLink = snapChatLink
        }
        
        _userRef = DataService.ds.REF_USERS.child(_userKey)
        
    }
    
    
    var firstName: String {
        get{
            return _firstName;
        }
        set{
            _firstName = newValue;
        }
    }
    
    var lastName: String{
        get{
            return _lastName
        }
        set{
            _lastName = newValue
        }
    }
    
    var password: String{
        get{
            return _password
        }set{
            _password = newValue
        }
    }
    
    var email: String{
        get{
            return _email
        }set{
            _email = newValue
        }
    }
    
    var profileImage: String{
        get{
            return _profileImage
        }set{
            _profileImage = newValue
        }
    }
    
    var provider: String{
        get{
            return _provider
        }
        set{
            _provider = newValue
        }
    }
    
    var about: String{
        get{
            return _about
        }
        set{
            _about = newValue
        }
    }
    
    var phoneNumber: String{
        get{
            return _phoneNumber ?? ""
        }
        set{
            _phoneNumber = newValue
        }
    }
    
    var facebookLink: String{
        get{
            return _facebookLink ?? ""
        }
        set{
            _facebookLink = newValue
        }
    }
    
    var twitterLink: String{
        get{
            return _twitterLink ?? ""
        }
        set{
            _twitterLink = newValue
        }
    }
    
    var instagramLink: String{
        get{
            return _instagramLink ?? ""
        }
        set{
            _instagramLink = newValue
        }
    }
    
    var snapChatLink: String{
        get{
            return _snapChatLink ?? ""
        }
        set{
            _snapChatLink = newValue
        }
    }
    
    
}
