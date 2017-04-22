//
//  EventDetailsVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 3/5/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController {
    
    var postData = Post()
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(postData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 320, height: 1320);

        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //remove "back" from the cursor side in the navigation bar
//        self.navigationController?.navigationBar.backItem?.title="Back"
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
