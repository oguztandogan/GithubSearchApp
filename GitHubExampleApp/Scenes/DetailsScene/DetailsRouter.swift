//
//  DetailsRouter.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 3.08.2022.
//

import Foundation
import UIKit

protocol DetailsRouterInterface: AnyObject {
    func presentGithubWebView(url: String)
}

class DetailsRouter: DetailsRouterInterface {
    
    func presentGithubWebView(url: String) {
        guard let topMostViewController = UIApplication.topViewController() else { return }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let githubWebView = storyboard.instantiateViewController(withIdentifier: "GithubWebView") as! GithubWebView
        githubWebView.urlString = url
        topMostViewController.navigationController?.present(githubWebView, animated: true)
    }
}
