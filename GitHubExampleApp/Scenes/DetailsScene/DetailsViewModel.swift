//
//  DetailsViewModel.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation

protocol DetailsViewModelInterface {
    func getData() -> DetailsViewModelData
    func presentGithubWebView()
    func getFormatedDate() -> String
}

class DetailsViewModel {
    
    private let viewModelData: DetailsViewModelData?
    private var detailsRouter: DetailsRouterInterface = DetailsRouter()
    private let dateFormatter = DateFormatterHelper()

    init(viewModelData: DetailsViewModelData?) {
        self.viewModelData = viewModelData
    }
}

extension DetailsViewModel: DetailsViewModelInterface {
    func getData() -> DetailsViewModelData {
        return viewModelData!
    }
    
    func presentGithubWebView() {
        guard let url = viewModelData?.htmlUrl else { return }
        detailsRouter.presentGithubWebView(url: url)
    }
    
    /// Gets formatted date
    /// - Returns: Returns formatted date
    func getFormatedDate() -> String {
        return dateFormatter.formatDate(dateText: viewModelData?.creationDate)
    }
}

