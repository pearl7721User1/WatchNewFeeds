//
//  CoreDataStack.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

protocol FeedSetup {
    func doesFeedExist() -> Bool
    func setupFeed()
}


class CoreDataStack {
    
    enum error: Error {
        case executionError(guids: [String])
    }
    
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
    
    func deleteEpisodes(guidArray: [String], context: NSManagedObjectContext) throws {
        
        // TODO: - delete
        var failedGuidList = [String]()
        
        context.performAndWait {
            
            for (_,guid) in guidArray.enumerated() {
                
                let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest(guid: guid)
                var mightBeEpisode: Episode?
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    mightBeEpisode = fetchResult.first
                } catch {
                    failedGuidList.append(guid)
                    continue
                }
                
                guard let episodeOfInterest = mightBeEpisode else {
                    failedGuidList.append(guid)
                    continue
                }
                
                context.delete(episodeOfInterest)
                
                // save context
                do {
                    try context.save()
                } catch {
                    failedGuidList.append(guid)
                    continue
                }
                
                // notify changes
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey:[episodeOfInterest.objectID]],into: [self.persistentContainer.viewContext])
            }
            
        }
        
        if failedGuidList.count > 0 {
            let theError = CoreDataStack.error.executionError(guids: failedGuidList)
            throw theError
        }
        
        context.reset()
    }
    
    func updateEpisodes(episodeTuples: [EpisodeTuple], context: NSManagedObjectContext) throws {
        
        // TODO: - delete
        var failedGuidList = [String]()
        
        context.performAndWait {
            
            for (_,episodePropertiesTuple) in episodeTuples.enumerated() {
                
                let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest(guid: episodePropertiesTuple.guid)
                var mightBeEpisode: Episode?
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    mightBeEpisode = fetchResult.first
                } catch {
                    failedGuidList.append(episodePropertiesTuple.guid)
                    continue
                }
                
                guard let episodeOfInterest = mightBeEpisode else {
                    failedGuidList.append(episodePropertiesTuple.guid)
                    continue
                }
                
                episodeOfInterest.desc = episodePropertiesTuple.desc
                episodeOfInterest.fileSize = episodePropertiesTuple.fileSize
                episodeOfInterest.link = episodePropertiesTuple.link
                episodeOfInterest.pubDate = episodePropertiesTuple.pubDate as NSDate
                episodeOfInterest.title = episodePropertiesTuple.title
                
                // save context
                do {
                    try context.save()
                } catch {
                    failedGuidList.append(episodePropertiesTuple.guid)
                    continue
                }
                
                // notify changes
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey:[episodeOfInterest.objectID]],into: [self.persistentContainer.viewContext])
                
            }
            
        }
        
        if failedGuidList.count > 0 {
            let theError = CoreDataStack.error.executionError(guids: failedGuidList)
            throw theError
        }
        
        context.reset()
    }
    
    func insertEpisodes(episodeTuples: [EpisodeTuple], to show:Show, context: NSManagedObjectContext) throws {
        
        var failedGuidList = [String]()
        
        for (_,episodePropertiesTuple) in episodeTuples.enumerated() {
            
            let episode = Episode(context: context)
            
            // feed properties
            episode.title = episodePropertiesTuple.title
            episode.desc = episodePropertiesTuple.desc
            episode.link = episodePropertiesTuple.link
            episode.guid = episodePropertiesTuple.guid
            episode.pubDate = episodePropertiesTuple.pubDate as NSDate
            episode.fileSize = episodePropertiesTuple.fileSize
            episode.show = show
            
            // save context
            do {
                try context.save()
            } catch {
                failedGuidList.append(episodePropertiesTuple.guid)
            }
        }
        
        if failedGuidList.count > 0 {
            let theError = CoreDataStack.error.executionError(guids: failedGuidList)
            throw theError
        }
        
        context.reset()
        
    }
    
    func insertShow(showTuple: ShowTuple, context: NSManagedObjectContext) -> Show? {
        
        let show = Show(context: context)

        // feed properties
        show.title = showTuple.title
        show.desc = showTuple.desc
        show.language = showTuple.language
        show.link = showTuple.link
        show.rssFeedUrl = showTuple.rssFeedUrl
        
        DispatchQueue.global().async {
            if let url = URL(string: showTuple.logoImageUrlString),
                let data = try? Data(contentsOf: url) as NSData {
                show.logoImage = data
                
                try? context.save()
                
                // reset context
                context.reset()
            }
        }
        
        show.pubDate = showTuple.pubDate as NSDate

        // save context
        do {
            try context.save()
        } catch {
            return nil
        }
        
        // do not reset context at this time
        return show
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
    
    func fetchShow(rssFeedUrl: String, context: NSManagedObjectContext) throws -> Show? {
        
        let fetchRequest = Show.fetchRequest(rssFeedUrl: rssFeedUrl)
        var storedShows: [Show]?
        do {
            storedShows = try context.fetch(fetchRequest)
        } catch {
            throw error
        }
        
        return storedShows?.first
    }
    
}
