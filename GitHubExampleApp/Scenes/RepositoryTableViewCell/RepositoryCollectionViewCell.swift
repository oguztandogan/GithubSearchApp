//
//  CollectionViewCell.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 5.08.2022.
//

import UIKit

class RepositoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var repoImage: UIImageView!{
        didSet {
            repoImage.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoOwner: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    var favouriteButtonCallback: (() -> ()) = { }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        favouriteButtonCallback()

    }
    
}

extension RepositoryCollectionViewCell {
    
    func updateCell(with result: Repository,
                    saveButtonImage: UIImage) {
        repoName.text = result.name ?? "No name"
        repoOwner.text = result.owner?.login ?? "No owner name"
        repoDescription.text = result.itemDescription ?? "No description"
        saveButton.setImage(saveButtonImage, for: .normal)
    }
    
    func updateSavedRepositoriesCell(with result: SavedRepositories,
                                     image: UIImage) {
        repoName.text = result.repoName
        repoOwner.text = result.repoOwner
        repoDescription.text = result.repoDescription
        repoImage.image = image
        saveButton.setImage(UIImage(named: "filledheart"), for: .normal)
    }
    
    func updateSavedButtonImage(image: UIImage) {
        saveButton.setImage(image, for: .normal)
    }
}
