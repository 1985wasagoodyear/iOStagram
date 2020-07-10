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
import BasicKeychain
import InstagramBD

enum Storyboards: String {
    case main = "Main"
    func instantiate<ViewController: UIViewController>(named name: String) -> ViewController {
        let storyboard = UIStoryboard(name: rawValue,
                                      bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: name) as? ViewController else {
            fatalError("ViewController named: '\(name)' not found on Storyboard '\(rawValue)'")
        }
        return viewController
    }
}

final class SignInCoordinator {
    var window: UIWindow?
    
    func start() {
        assert(window != nil)
        guard let window = window else { return }
        window.rootViewController = createInitialViewController()
        window.makeKeyAndVisible()
    }
    
    func createInitialViewController() -> UIViewController {
        let keychainItem = BasicKeychain(name: "yu.iOStagram",
                                         service: "accessToken")
        let initialVC: UIViewController
        let storyboard = Storyboards.main
        if let accessToken = try? keychainItem.get() {
            initialVC = storyboard.instantiate(named: "GalleryViewController")
        } else {
            initialVC = IGLoginViewController(credentials: API.Credentials.secret)
        }
        return initialVC
    }
}
