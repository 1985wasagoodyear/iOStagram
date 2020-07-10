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
    let completion: (Error?) -> Void
    
    /// TODO: - something about `completion` not being thread-safe
    public init(credentials: API.Credentials,
                completion: @escaping (Error?) -> Void) {
        self.credentials = credentials
        self.completion = completion
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
            let redirectRequest = credentials.makeRedirect(from: requestUrl) {
            decisionHandler(.cancel)
            self.fetchAccessToken(redirectRequest: redirectRequest)
            return
        }
        decisionHandler(.allow)
    }

    func fetchAccessToken(redirectRequest: URLRequest) {
        URLSession.shared.dataTask(with: redirectRequest) { [weak self] data, response, error in
            let completion = self?.completion
            if let error = error {
                completion?(error)
                return
            }
            guard let data = data else {
                // TODO: - Toss an Error here
                print("toss an error here")
                completion?(nil)
                return
            }
            do {
                try self?.parseAndSaveToken(from: data)
                completion?(nil)
            } catch {
                completion?(error)
            }
        }.resume()
    }
    
    func parseAndSaveToken(from data: Data) throws {
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(IGAccessTokenResponse.self, from: data)
        let keychainItem = BasicKeychain(name: "yu.iOStagram",
                                         service: "accessToken")
        try? keychainItem.set(tokenResponse.accessToken)
    }
}

