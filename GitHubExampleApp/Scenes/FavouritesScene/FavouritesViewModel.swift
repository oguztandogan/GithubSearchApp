//
//  FavouritesViewModel.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation
import UIKit

class FavouritesViewModel {
    var savedRepositories = [SavedRepositories]()
    var listenDataCallback: (() -> Void)?
    
    /// Fetches saved repositories from CoreData
    func fetchSavedRepositories() {
        CoreDataManager.shared.fetchSavedItems { [weak self] result in
            self?.savedRepositories = result
            self?.listenDataCallback?()
        }
    }
    
    func getNumberOfItems() -> Int {
        return savedRepositories.count
    }
    
    func getSavedRepositoryList(index: Int) -> SavedRepositories? {
        return savedRepositories[index]
    }
    
    func getImage(index: Int) -> UIImage? {
        guard let imageData = savedRepositories[index].image else {
            return UIImage(named: "noavatar")
        }
        let image = UIImage(data: imageData)
        return image
    }
    
    func getRepositoryDetails(index: Int) -> DetailsViewModelData {
        let detailsViewModelData = DetailsViewModelData(repoName: savedRepositories[index].repoName,
                                                        repoDescription: savedRepositories[index].repoDescription,
                                                        language: savedRepositories[index].language,
                                                        forks: savedRepositories[index].forks,
                                                        creationDate: savedRepositories[index].creationDate,
                                                        htmlUrl: savedRepositories[index].htmlUrl,
                                                        starsCount: savedRepositories[index].starsCount)
        return detailsViewModelData
    }
    
    func removeRepository(index: Int) {
        let deletedTask = savedRepositories[index]
        CoreDataManager.shared.deleteItem(deletedTask: deletedTask)
        savedRepositories.remove(at: index)

        listenDataCallback?()
    }
}
