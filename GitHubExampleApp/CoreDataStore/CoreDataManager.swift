//
//  CoreDataManager.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 4.08.2022.
//

import Foundation
import CoreData
import UIKit

//let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
//let newNote = Note(context: managedContext)
//newNote.setValue(Date(), forKey: #keyPath(Note.dateAdded))
//newNote.setValue(noteText, forKey: #keyPath(Note.noteText))
//newNote.setValue(priorityColor, forKey: #keyPath(Note.priorityColor))
//self.notes.insert(newNote, at: 0)
//AppDelegate.sharedAppDelegate.coreDataStack.saveContext()

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
    func saveContext () {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func fetchSavedItems(completion: @escaping (([SavedRepositories]) -> ())) {
        guard let managedContext = managedObjectContext else {
            return
            
        }
        let fetchRequest = NSFetchRequest<SavedRepositories>(entityName: String(describing: SavedRepositories.self))
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            completion(fetchResults)
            
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    func deleteItem(deletedTask: NSManagedObject) {
        guard let managedContext = managedObjectContext else { return }
        
        
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedRepositories")
        fetchedRequest.returnsObjectsAsFaults = false
        managedContext.delete(deletedTask)
        saveContext()
    }
    
}
