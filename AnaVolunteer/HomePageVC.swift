//
//  HomePageVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/25/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import Elissa

class HomePageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString,UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        someActionTrigger()
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    print ("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //remove "back" from the cursor side in the navigation bar
        self.navigationController?.navigationBar.backItem?.title=""
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_ID)
        print("HomePageVC: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLoginPage", sender: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //loop into the post data
        let post = posts[indexPath.row]
        print("HomePageVC: \(post.eventCaption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = HomePageVC.imageCache.object(forKey: post.imageUrl as NSString){
                //configure your cell
                cell.configureCell(post: post,img: img)
                return cell
            }else{
                //configure your cell
                cell.configureCell(post: post)
                return cell
            }
        }else{
            return PostCell()
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func someActionTrigger() {
        
        let elissaConfig = ElissaConfiguration()
        elissaConfig.message = "Share An Event"
        elissaConfig.image = UIImage(named: "event")
        elissaConfig.font = UIFont.systemFont(ofSize: 17)
        elissaConfig.textColor = UIColor(red: 91/255, green: 91/255, blue: 91/255, alpha: 1.0)
        elissaConfig.backgroundColor = UIColor(red: 241/255, green: 215/255, blue: 85/255, alpha: 1.0)
        
        showElissaFromTabbar(at: 2, configuration: elissaConfig) {
            Elissa.dismiss()
        }
    }
}
