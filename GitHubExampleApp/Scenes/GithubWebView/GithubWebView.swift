//
//  GithubWebView.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 3.08.2022.
//

import Foundation
import UIKit
import WebKit


class GithubWebView: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var urlString: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view = webView
        setToolBar()
        setWebView()
    }
    
    // MARK: - Methods
    
    /// Setup WebView
    func setWebView() {
        guard let urlString = urlString else {
            return
        }
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    /// Configures toolbar of the WebView
    fileprivate func setToolBar() {
        let screenWidth = self.view.bounds.width
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [backButton]
        webView.addSubview(toolBar)
        // Constraints
        toolBar.topAnchor.constraint(equalTo: webView.topAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
    }
    
    /// ToolBar's goBack button's action
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
