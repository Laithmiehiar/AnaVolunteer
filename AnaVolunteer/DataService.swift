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
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService{
    
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DATA_BASE
    private var _REF_USERS = DATA_BASE.child("users")
    private var _REF_POSTS = DATA_BASE.child("posts")
    
    //Storage references
    private var _REF_POSTS_IMAGES = STORAGE_BASE.child("post-pics")
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }
    
    var REF_POSTS_IMAGES: FIRStorageReference{
        return _REF_POSTS_IMAGES
    }
    func createFirebaseDBUser(uid:String, userData:Dictionary<String,String>){
        _REF_USERS.child(uid).updateChildValues(userData)
    }
//    func validateFirebaseDBUser(uid:String, userData:Dictionary<String,String>){
//        _REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.hasChild(userData["email"]!){
//                print("true rooms exist")
//            }else{
//                print("false room doesn't exist")
//            }
//            
//            
//        })
//    }
}
