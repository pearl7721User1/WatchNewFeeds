//
//  CoreDataStack.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    
    convenience init(with persistentContainer:NSPersistentContainer) {
        self.init()
        self.persistentContainer = persistentContainer
    }
    
    func fetchAllEpisodes(context: NSManagedObjectContext) throws -> [Episode] {
        
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        var storedEpisodes: [Episode]?
        do {
            storedEpisodes = try context.fetch(fetchRequest)
        } catch {
            throw error
        }
        
        return storedEpisodes!
    }
    
    func addEpisodes(dictArray: [[String:Any]], context: NSManagedObjectContext) throws {
        
        for (_,dict) in dictArray.enumerated() {
            
            if let episodeProperties = try? Episode.deserialized(dict: dict) {
                
                let episode = Episode(context: context)
                
                // feed properties
                episode.title = episodeProperties.title
                episode.desc = episodeProperties.desc
                episode.link = episodeProperties.link
                episode.guid = episodeProperties.guid
                episode.pubDate = episodeProperties.pubDate as NSDate
                episode.fileSize = episodeProperties.fileSize
                
            } else {
                
                // throw exception
            }
            
            
        }
        
        // save context
        do {
            try context.save()
        } catch {
            throw error
        }
        
    }
    
    func updateEpisodes(dictArray: [[String:Any]], context: NSManagedObjectContext) throws {
        
        for (_,dict) in dictArray.enumerated() {
            
            if let episodeProperties = try? Episode.deserialized(dict: dict) {
                
                let fetchRequest = Episode.fetchRequest(guid: episodeProperties.guid)
                var episode: Episode?
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    
                    if fetchResult.count != 1 {
                        print("guid:\(episodeProperties.guid) is more than one or has not been found")
                    }
                    
                    episode = fetchResult.first
                    
                } catch {
                    print(error.localizedDescription)
                    continue
                }
                
                // update nsmanaged object
                episode?.title = episodeProperties.title
                episode?.desc = episodeProperties.desc
                episode?.link = episodeProperties.link
                episode?.guid = episodeProperties.guid
                episode?.pubDate = episodeProperties.pubDate as NSDate
                episode?.fileSize = episodeProperties.fileSize
                
            } else {
                
                // throw exception
            }
            
        }
        
        // save context
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WatchNewFeeds")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
