//
//  BaseViewController.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation
import UIKit

/// Base View Controller
class BaseViewController: UIViewController {
    
    var loaderView = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupLoaderView()
    }
    
    /// Func to handles the navigation controller
    func setupNavigationController() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.2888296772)
            appearance.titleTextAttributes = [.font:
                                                UIFont.boldSystemFont(ofSize: 20.0),
                                              .foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "Repositories", style: .plain, target: nil, action: nil)
            
        } else {
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.2888296772)
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: "Repositories", style: .plain, target: nil, action: nil)

        }
    }
    
    // MARK: - Methods
    
    /// Setup loader view
    func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderView)
        loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
