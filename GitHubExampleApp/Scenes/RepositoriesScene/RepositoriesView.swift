//
//  RepositoriesView.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 31.07.2022.
//

import Foundation
import UIKit



/// Repositories View
class RepositoriesView: BaseViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel = RepositoriesViewModel(networkService: DefaultNetworkService(), dateFormatter: DateFormatterHelper())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupSearchControllerConfigurations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    // MARK: - Methods
    
    /// Configures TableView
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "RepositoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RepositoryCollectionViewCell")
    }
    
    /// Callback when the url request at the view model finishes.
    private func reloadTableView() {
        viewModel.listenDataCallback = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.loaderView.stopAnimating()
            }
        }
    }
    
    // MARK: - Actions
    
    /// SegmentedControl's segment's action
    @IBAction func segmentedControlAction(_ sender: Any) {
        viewModel.eraseTableViewData()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.setTimeRange(timeRange: .dayAgo)
        case 1:
            viewModel.setTimeRange(timeRange: .weekAgo)
        case 2:
            viewModel.setTimeRange(timeRange: .monthAgo)
        default:
            break
        }
    }
    
}

    //MARK: - Collection View Methods

extension RepositoriesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepositoryCollectionViewCell", for: indexPath) as? RepositoryCollectionViewCell,
              let data = viewModel.getRepositoryList(index: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        let saveButtonImage = viewModel.getSaveButtonImage(index: indexPath.row)
        cell.favouriteButtonCallback = { [weak self] in
            self?.viewModel.decideToSaveOrDeleteRepository(index: indexPath.row)
            cell.updateSavedButtonImage(image: (self?.viewModel.changeSaveButtonImage(index: indexPath.row))!)
        }
        
        viewModel.fetchImages(imageUrl: data.owner?.avatarURL) { image in
            DispatchQueue.main.async {
                cell.repoImage.image = image
            }
        }
        cell.updateCell(with: data,
                        saveButtonImage: saveButtonImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 4{
            loaderView.startAnimating()
            viewModel.getMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.size.width/2 - 20, height: 80)
        } else {
            return CGSize(width: view.frame.size.width, height: 80)

        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailsView") as! DetailsView
        let repositoryDetailsViewModel = DetailsViewModel(viewModelData: viewModel.getRepositoryDetails(index: indexPath.row))
        detailsView.viewModel = repositoryDetailsViewModel
        navigationController?.pushViewController(detailsView, animated: true)
    }
 
}


// MARK: - SearchBar Methods

extension RepositoriesView: UISearchBarDelegate {
    
    /// Setup Search Controller
    func setupSearchControllerConfigurations() {
        searchController.searchResultsUpdater = viewModel.getSearchResultUpdater()
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        loaderView.startAnimating()
    }
    
}
