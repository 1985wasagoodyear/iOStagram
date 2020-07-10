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
import InstagramBD

final class SignInViewController: UIViewController {
    
    // MARK: - Storyboard Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var signInButton: UIButton! {
        didSet {
            signInButton?.roundify()
        }
    }
    @IBOutlet var footerLabel: UILabel!
    
    // MARK: - Navigation Properties
    
    weak var coordinator: SignInCoordinator?
    
    // MARK: - Custom Action Methods
    
    @IBAction func signInButtonAction(_ sender: Any) {
        let loginVC = IGLoginViewController(credentials: API.Credentials.secret,
                                            completion: handleLogin)
        present(loginVC, animated: true)
    }
    
}

// MARK: - Navigation Methods

extension SignInViewController {
    func handleLogin(error: Error?) {
        if let error = error {
            handleError(error: error)
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.coordinator?.gotoSignedInExperience()
        }
    }
}

// MARK: - Error Handlers

extension SignInViewController {
    func handleError(error: Error) {
        // TODO: - handle error here, somehow
        print(error)
    }
    
}
