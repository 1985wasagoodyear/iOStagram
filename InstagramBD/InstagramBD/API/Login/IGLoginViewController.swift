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
import WebKit
import BasicKeychain
import CommonUtility

public final class IGLoginViewController: UIViewController {
    
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

    let credentials: API.Credentials
    
    public init(credentials: API.Credentials) {
        self.credentials = credentials
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("initWithDecoder: unavailable")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = credentials.makeUrl() else {
            return
        }
        webView.load(URLRequest(url: url))
    }

}

extension IGLoginViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestUrl = navigationAction.request.url,
            let redirectUrl = credentials.makeRedirect(from: requestUrl) {
            decisionHandler(.cancel)
            URLSession.shared.dataTask(with: redirectUrl) { data, response, error in
                print(data ?? response ?? error ?? "huh")
                // once token is received, return user to normal flow and use for other things...
                guard let data = data else {
                    // TODO: - Toss an Error here
                    print("toss an error here")
                    return
                }
                let decoder = JSONDecoder()
                let tokenResponse = try! decoder.decode(IGAccessTokenResponse.self, from: data)
                print(tokenResponse)
                
                let keychainItem = BasicKeychain(name: "yu.iOStagram",
                                                 service: "accessToken")
                try? keychainItem.set(tokenResponse.accessToken)
                
            }.resume()
            return
        }
        decisionHandler(.allow)
    }
}

