//
//  DataService.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/27/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation
import Firebase

let DATA_BASE = FIRDatabase.database().reference()

class DataService{

    static let ds = DataService()
    
    private var _REF_BASE = DATA_BASE
    private var _REF_USERS = DATA_BASE.child("users")
    private var _REF_POSTS = DATA_BASE.child("posts")

    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }
    
    func createFirebaseDBUser(uid:String, userData:Dictionary<String,String>){
        _REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
