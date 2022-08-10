//
//  FavouritesView.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 1.08.2022.
//

import Foundation
import UIKit

class FavouritesView: BaseViewController {
    
    //MARK: - Outlets and Variables
    private var viewModel = FavouritesViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableView()
        viewModel.fetchSavedRepositories()
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "RepositoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RepositoryCollectionViewCell")
    }
    
    /// Callback when the request at the view model finishes.
    private func reloadTableView() {
        viewModel.listenDataCallback = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView Methods

extension FavouritesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepositoryCollectionViewCell", for: indexPath) as? RepositoryCollectionViewCell,
              let data = viewModel.getSavedRepositoryList(index: indexPath.row),
              let image = viewModel.getImage(index: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        cell.favouriteButtonCallback = { [weak self] in
            self?.viewModel.removeRepository(index: indexPath.row)
        }
        
        cell.updateSavedRepositoriesCell(with: data, image: image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.size.width/2 - 20, height: 80)
        } else {
            return CGSize(width: view.frame.size.width, height: 80)

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailsView") as! DetailsView
        let repositoryDetailsViewModel = DetailsViewModel(viewModelData: viewModel.getRepositoryDetails(index: indexPath.row))
        detailsView.viewModel = repositoryDetailsViewModel
        navigationController?.pushViewController(detailsView, animated: true)
    }
 
}
