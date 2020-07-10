//
//  ISAppDelegate.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit
import BasicKeychain


@UIApplicationMain
final class ISAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainCoordinator = SignInCoordinator()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        mainCoordinator.window = window
        mainCoordinator.start()
        return true
    }

}
