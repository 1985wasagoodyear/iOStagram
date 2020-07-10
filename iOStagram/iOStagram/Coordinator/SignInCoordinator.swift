//
//  SignInCoordinator.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit
import InstagramBD

final class SignInCoordinator {
    var window: UIWindow?
    
    func start() {
        assert(window != nil)
        guard let window = window else { return }
        window.rootViewController = createInitialViewController()
        window.makeKeyAndVisible()
    }
    
    func createInitialViewController() -> UIViewController {
        let initialVC: UIViewController
        let storyboard = Storyboards.main
        if API.hasToken {
            initialVC = storyboard.instantiate(named: "GalleryViewController")
        } else {
            initialVC = Storyboards.makeSignInViewController(coordinator: self)
        }
        return initialVC
    }
    
    func gotoSignedInExperience() {
        let signedInVC = Storyboards.main.instantiate(named: "GalleryViewController")
        window?.rootViewController = signedInVC
        window?.makeKeyAndVisible()
    }
    
}
