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
        if let user = try? InstaUser(credentials: .secret) {
            let signedInVC: GalleryViewController = Storyboards.main.instantiate(named: "GalleryViewController")
            signedInVC.user = user
            initialVC = signedInVC
        } else {
            initialVC = Storyboards.makeSignInViewController(coordinator: self)
        }
        return initialVC
    }
    
    func gotoSignedInExperience(user: InstaUser) {
        let signedInVC: GalleryViewController = Storyboards.main.instantiate(named: "GalleryViewController")
        signedInVC.user = user
        window?.rootViewController = signedInVC
        window?.makeKeyAndVisible()
    }
    
}
