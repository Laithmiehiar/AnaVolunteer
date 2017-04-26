//
//  WebViewVC.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 4/23/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//

import Foundation
import UIKit

class WebViewVC: UIViewController{
    @IBOutlet weak var webView: UIWebView!
    var urlString: String!
    var appType: String!
    
    override func viewDidLoad() {
    
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(url: url as! URL)
        
        webView.loadRequest(request as URLRequest)
    }
}
