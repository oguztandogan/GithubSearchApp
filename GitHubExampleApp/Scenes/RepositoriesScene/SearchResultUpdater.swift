//
//  SearchResultUpdater.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 3.08.2022.
//

import Foundation
import UIKit

/// Search Result Updater Delegate binds to SearchController

protocol SearchResultUpdaterDelegate: AnyObject {
    func updatedText(with text: String?)
    func eraseSearchResults()
}

class SearchResultUpdater: NSObject, UISearchResultsUpdating {
    
    weak var delegate: SearchResultUpdaterDelegate?
    
    private var searchWorkItem: DispatchWorkItem?
    
    init(delegate: SearchResultUpdaterDelegate) {
        self.delegate = delegate
    }
    
    /// Search text updater by implementing throttle
    /// - Parameter searchController: Binded searchController
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text, text.count > 2 else {
            return }
        
        searchWorkItem?.cancel()
        
        let newTask = DispatchWorkItem { [weak self] in
            self?.delegate?.updatedText(with: text)
        }
        
        self.searchWorkItem = newTask
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newTask)
        
    }
    
}
