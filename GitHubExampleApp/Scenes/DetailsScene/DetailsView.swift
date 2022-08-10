//
//  DetailsView.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation
import UIKit

class DetailsView: BaseViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var viewModel: DetailsViewModelInterface?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIComponents()
    }
    
    /// Sets ui components' datas
    private func setUIComponents() {
        let data = viewModel?.getData()
        descriptionLabel.text = data?.repoDescription
        languageLabel.text = data?.language
        forksLabel.text = data?.forks
        starsLabel.text = data?.starsCount
        createdAtLabel.text = viewModel?.getFormatedDate()
        self.navigationItem.title = data?.repoName
    }
    
    /// Navigates to WebView
    @IBAction func githubWebViewAction(_ sender: Any) {
        viewModel?.presentGithubWebView()
    }
}
