//
//  RepositoriesViewModel.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 31.07.2022.
//

import Foundation
import UIKit

enum TimeRangeForSearch {
    case dayAgo
    case weekAgo
    case monthAgo
}

/// View Model of Repositories
class RepositoriesViewModel {
    
    // MARK: - Variables
    
    let queue = DispatchQueue(label: "myQueue", attributes: .concurrent, target: .global())
    private var savedRepositories = [SavedRepositories]()
    var listenDataCallback: (() -> Void)?
    private let dispatchGroup = DispatchGroup()
    private let fetchRepositoriesDispatchGroup = DispatchGroup()
    
    private var repositoriesList: [Repository?] = []
    private var images: [UIImage?] = []
    private var pageNumber: Int = 1
    private var searchedText: String?
    private let networkService: NetworkService
    private var isPaginationEnabled: Bool = true
    private var dateFormatter: DateFormatterHelper?
    private var searchTimeRange: TimeRangeForSearch = .dayAgo
    
    
    private lazy var searchResultUpdater = SearchResultUpdater(delegate: self)
    
    init(networkService: NetworkService,
         dateFormatter: DateFormatterHelper) {
        self.networkService = networkService
        self.dateFormatter = dateFormatter
    }
    
    
    /// DispatchGroup of the requests
    /// - Parameters:
    ///   - searchText: Desired search text
    ///   - isPaginationEnabled: Bool parameter for pagination
    func fetchData(searchText: String,
                   isPaginationEnabled: Bool) {
        dispatchGroup.enter()
        fetchRepositories(searchText: searchText,
                          isPaginationEnabled: isPaginationEnabled) {
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchSavedRepositories {
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: queue) {
            self.listenDataCallback?()
        }
    }
    
    
    /// Fetches Repositories
    /// - Parameters:
    ///   - searchText: Desired search text
    ///   - isPaginationEnabled: Bool parameter for pagination
    ///   - completion: Callback of request ending
    func fetchRepositories(searchText: String,
                           isPaginationEnabled: Bool,
                           completion: @escaping () -> ()) {
        searchedText = searchText
        guard let desiredTimeRange = getDesiredTime(timeRange: searchTimeRange) else { return }
        let request = RepositoriesRequest(searchedText: searchedText ?? "",
                                          desiredTimeRange: desiredTimeRange,
                                          currentTime: dateFormatter?.getCurrentDate() ?? "",
                                          pageNumber: pageNumber.description)
        
        networkService.request(request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if isPaginationEnabled {
                    self.repositoriesList.append(contentsOf: data.items)
                } else {
                    self.repositoriesList = data.items
                }
                completion()
            case .failure(let error):
                print("errors")
                
            }
        }
    }
    
    /// Fetches Saved Repositories from CoreData
    /// - Parameter completion: Callback of the requests ending
    func fetchSavedRepositories(completion: @escaping () -> ()) {
        CoreDataManager.shared.fetchSavedItems { result in
            self.savedRepositories = result
            completion()
        }
    }
    
    /// Fetches Images
    /// - Parameters:
    ///   - imageUrl: Desired image url
    ///   - completion: Callback of the requests ending
    func fetchImages(imageUrl: String?, completion: @escaping (UIImage) -> ()) {
        networkService.downloadImage(imageURL: imageUrl) { result in
            switch result {
            case .success(let data):
                self.images.append(self.getImages(imageData: data))
                guard let image = self.getImages(imageData: data) else {
                    return
                }
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Converts image data to UIImage
    /// - Parameter imageData: Desired image data
    /// - Returns: Converted UIImage
    func getImages(imageData: Data?) -> UIImage? {
        guard let imageData = imageData else {
            return UIImage(named: "noavatar")!
        }
        return UIImage(data: imageData)
    }
    
    
    
    /// Returns the desired search range
    /// - Parameter timeRange: Desired search range
    /// - Returns: Returns the search range
    private func getDesiredTime(timeRange: TimeRangeForSearch) -> String? {
        
        switch timeRange {
        case .dayAgo:
            return dateFormatter?.getOneDayAgoDate()
        case .weekAgo:
            return dateFormatter?.getOneWeekAgoDate()
        case .monthAgo:
            return dateFormatter?.getOneMonthAgoDate()
        }
    }
    
    /// Sets the desired time range and calls the fetch func
    /// - Parameter timeRange: Desired time range
    func setTimeRange(timeRange: TimeRangeForSearch) {
        searchTimeRange = timeRange
        guard let searchedText = searchedText,
              searchedText.count > 2 else {
            return
        }
        fetchData(searchText: searchedText, isPaginationEnabled: false)
        
    }
    
    /// Number of items for TableView
    /// - Returns: Number of items
    func getNumberOfItems() -> Int? {
        return repositoriesList.count
    }
    
    /// Data of the table view
    /// - Parameter index: Cell index
    /// - Returns: Data for cell
    func getRepositoryList(index: Int) -> Repository? {
        return repositoriesList[index]
    }
    
    /// Method for pagination
    func getMoreData() {
        pageNumber += 1
        fetchData(searchText: searchedText ?? "", isPaginationEnabled: true)
        
    }
    
    /// Erases the table view data
    func eraseTableViewData() {
        repositoriesList.removeAll()
        images.removeAll()
        listenDataCallback?()
    }
    
    /// Gets Repository Details
    /// - Parameter index: Desired repository's index
    /// - Returns: Repository Details Data
    func getRepositoryDetails(index: Int) -> DetailsViewModelData {
        let detailsViewModelData = DetailsViewModelData(repoName: repositoriesList[index]?.name,
                                                        repoDescription: repositoriesList[index]?.itemDescription,
                                                        language: repositoriesList[index]?.language,
                                                        forks: repositoriesList[index]?.forks?.description,
                                                        creationDate: repositoriesList[index]?.createdAt,
                                                        htmlUrl: repositoriesList[index]?.htmlURL,
                                                        starsCount: repositoriesList[index]?.starsCount?.description)
        return detailsViewModelData
    }
    
    /// Sets search result updater
    /// - Returns: Search Result Updater
    func getSearchResultUpdater() -> SearchResultUpdater {
        return searchResultUpdater
    }
    
}

// MARK: - Search Result Updater Delegate Methods

extension RepositoriesViewModel: SearchResultUpdaterDelegate {
    
    /// Triggered when the search text changes
    /// - Parameter text: Input text of search bar
    func updatedText(with text: String?) {
        guard let text = text else { return }
        fetchData(searchText: text, isPaginationEnabled: false)
    }
    /// Erases table view data
    func eraseSearchResults() {
        eraseTableViewData()
    }
}

// MARK: - Core Data Methods

extension RepositoriesViewModel {
    
    func decideToSaveOrDeleteRepository(index: Int) {
        if !checkSavedStatus(repoId: repositoriesList[index]?.id?.description ?? "") {
            saveRepository(index: index)
        } else {
            removeRepository(index: index)
        }
        
    }
    /// Saves repository to favourites list
    /// - Parameter index: Repository index
    func saveRepository(index: Int) {
        guard let managedContext = CoreDataManager.shared.managedObjectContext else { return }
        let newRepository = SavedRepositories(context: managedContext)
        newRepository.setValue(repositoriesList[index]?.createdAt, forKey: #keyPath(SavedRepositories.creationDate))
        newRepository.setValue(repositoriesList[index]?.starsCount?.description, forKey: #keyPath(SavedRepositories.starsCount))
        let imageData = convertImageToData(image: images[index]!)
        newRepository.setValue(imageData, forKey: #keyPath(SavedRepositories.image))
        newRepository.setValue(repositoriesList[index]?.forks?.description, forKey: #keyPath(SavedRepositories.forks))
        newRepository.setValue(repositoriesList[index]?.htmlURL, forKey: #keyPath(SavedRepositories.htmlUrl))
        newRepository.setValue(repositoriesList[index]?.language, forKey: #keyPath(SavedRepositories.language))
        newRepository.setValue(repositoriesList[index]?.itemDescription, forKey: #keyPath(SavedRepositories.repoDescription))
        newRepository.setValue(repositoriesList[index]?.name, forKey: #keyPath(SavedRepositories.repoName))
        newRepository.setValue(repositoriesList[index]?.owner?.login, forKey: #keyPath(SavedRepositories.repoOwner))
        newRepository.setValue(repositoriesList[index]?.id?.description, forKey: #keyPath(SavedRepositories.repoId))
        savedRepositories.append(newRepository)
        CoreDataManager.shared.saveContext()
        
    }
    
    /// Check if the repository already saved
    /// - Parameter repoId: Repository's id
    /// - Returns: Bool value for if the repository already saved
    func checkSavedStatus(repoId: String) -> Bool {
        if savedRepositories.contains(where: { $0.repoId == repoId }) {
            return true
        } else {
            return false
        }
    }
    
    /// Gets the saved repository's index on the Core Data Model
    /// - Parameter repoId: Repository's id
    /// - Returns: Index of repository
    func getSavedRepoIndex(repoId: String?) -> Int {
        return savedRepositories.firstIndex { $0.repoId == repoId } ?? 0
    }
    
    /// Changes heart button's image
    /// - Parameter index: Repository's index
    /// - Returns: Heart button image
    func changeSaveButtonImage(index: Int) -> UIImage {
        if checkSavedStatus(repoId: repositoriesList[index]?.id?.description ?? "") {
            return UIImage(named: "filledheart")!
            
        } else {
            return UIImage(named: "emptyheart")!
            
        }
    }
    
    
    /// Converts image to data for storing on the Core Data
    /// - Parameter image: Desired image
    /// - Returns: Image's data
    func convertImageToData(image: UIImage) -> Data? {
        let jpegImageData = image.jpegData(compressionQuality: 1.0)
        return jpegImageData
    }
    
    /// Gets the save button image according to saved status
    /// - Parameter index: Repository's index
    /// - Returns: Heart button image
    func getSaveButtonImage(index: Int) -> UIImage {
        if !savedRepositories.contains(where: { $0.repoId == repositoriesList[index]?.id?.description }) {
            return UIImage(named: "emptyheart")!
        } else {
            return UIImage(named: "filledheart")!
        }
    }
    
    func removeRepository(index: Int) {
        guard let managedContext = CoreDataManager.shared.managedObjectContext else { return }
        let savedRepoIndex = getSavedRepoIndex(repoId: repositoriesList[index]?.id?.description)
        managedContext.delete(savedRepositories[savedRepoIndex])
        savedRepositories.remove(at: savedRepoIndex)
        CoreDataManager.shared.saveContext()
    }
    
}
