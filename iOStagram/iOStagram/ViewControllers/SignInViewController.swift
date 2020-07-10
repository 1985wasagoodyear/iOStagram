//
//  SignInViewController.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit


class SignInViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var signInButton: UIButton! {
        didSet {
            signInButton?.roundify()
        }
    }
    
    @IBOutlet var footerLabel: UILabel!
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
    }
    
}
