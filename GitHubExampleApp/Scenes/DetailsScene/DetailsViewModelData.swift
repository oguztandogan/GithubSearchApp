//
//  DetailsViewModelData.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 2.08.2022.
//

import Foundation

struct DetailsViewModelData {
    let repoName: String?
    let repoDescription: String?
    let language: String?
    let forks: String?
    let creationDate: String?
    let htmlUrl: String?
    let starsCount: String?
    
    init(repoName: String?,
         repoDescription: String?,
         language: String?,
         forks: String?,
         creationDate: String?,
         htmlUrl: String?,
         starsCount: String?) {
        self.repoName = repoName
        self.repoDescription = repoDescription
        self.language = language
        self.forks = forks
        self.creationDate = creationDate
        self.htmlUrl = htmlUrl
        self.starsCount = starsCount
    }
    
}
