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
class HomePageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.hideKeyboardWhenTappedAround()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        return cell
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
