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
import CommonUIUtilities

public final class IGLoginViewController: UIViewController {
    
    lazy var config: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        // do more setup for config here?
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
    let completion: (Result<InstaUser, Error>) -> Void
    
    /// TODO: - something about `completion` not being thread-safe
    public init(credentials: API.Credentials,
                completion: @escaping (Result<InstaUser, Error>) -> Void) {
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
        credentials.session.dataTask(with: redirectRequest) { [weak self] data, response, error in
            guard let weakSelf = self else { return }
            let completion = weakSelf.completion
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(AccessTokenError.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(API.Login.AccessToken.Response.self,
                                                  from: data)
                let user = try InstaUser(response, credentials: weakSelf.credentials)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

public extension IGLoginViewController {
    enum AccessTokenError: Error {
        case noData
    }
}
