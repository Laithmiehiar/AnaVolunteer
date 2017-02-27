//
//  DismissKeyboard.swift
//  AnaVolunteer
//
//  Created by Laith Mihyar on 2/26/17.
//  Copyright © 2017 Laith Mihyar. All rights reserved.
//


import UIKit
extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
