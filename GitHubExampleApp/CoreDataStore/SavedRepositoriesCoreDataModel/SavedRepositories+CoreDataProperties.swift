//
//  SavedRepositories+CoreDataProperties.swift
//  
//
//  Created by Oguz Tandogan on 4.08.2022.
//
//

import Foundation
import CoreData


extension SavedRepositories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRepositories> {
        return NSFetchRequest<SavedRepositories>(entityName: "SavedRepositories")
    }

    @NSManaged public var image: Data?
    @NSManaged public var repoName: String?
    @NSManaged public var repoDescription: String?
    @NSManaged public var starsCount: String?
    @NSManaged public var repoOwner: String?
    @NSManaged public var language: String?
    @NSManaged public var forks: String?
    @NSManaged public var creationDate: String?
    @NSManaged public var htmlUrl: String?
    @NSManaged public var repoId: String?


}
