//
//  IGLoginViewController.swift
//  Created 6/29/20
//  Using Swift 5.0
// 
//  Copyright © 2020 yu. All rights reserved.
//
//  https://github.com/1985wasagoodyear
//

import UIKit
import InstagramBD
import WebKit

class IGLoginViewController: UIViewController {
    
    lazy var config: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        return config
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero,
                                configuration: config)
        webView.fillIn(self.view)
        webView.navigationDelegate = self
        return webView
    }()

    let creds: API.Credentials = .secret
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = creds.makeUrl() else {
            return
        }
        webView.load(URLRequest(url: url))
    }

}

extension IGLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestUrl = navigationAction.request.url,
            let redirectUrl = creds.makeRedirect(from: requestUrl) {
            decisionHandler(.cancel)
            URLSession.shared.dataTask(with: redirectUrl) { data, response, error in
                print(data ?? response ?? error ?? "huh")
                // once token is received, return user to normal flow and use for other things...
            }.resume()
            return
        }
        decisionHandler(.allow)
    }
}

