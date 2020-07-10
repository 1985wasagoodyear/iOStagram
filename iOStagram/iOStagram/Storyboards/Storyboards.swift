//
//  Storyboards.swift
//  Created 7/10/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit

enum Storyboards: String {
    case main = "Main"
}

// MARK: - Instantiate ViewControllers

extension Storyboards {
    func instantiate<ViewController: UIViewController>(named name: String) -> ViewController {
        let storyboard = UIStoryboard(name: rawValue,
                                      bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: name) as? ViewController else {
            fatalError("ViewController named: '\(name)' not found on Storyboard '\(rawValue)'")
        }
        return viewController
    }
}

// MARK: - Static Functions

extension Storyboards {
    static func makeSignInViewController(coordinator: SignInCoordinator) -> SignInViewController {
        let signInVC: SignInViewController = main.instantiate(named: "SignInViewController")
        signInVC.coordinator = coordinator
        return signInVC
    }
}
