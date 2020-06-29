//
//  ViewController.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit
import InstagramBD

class ViewController: UIViewController {

    let creds: API.Credentials = .secret
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = creds.makeUrl() else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    

}

