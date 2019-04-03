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
    
    convenience init(with persistentContainer:NSPersistentContainer) {
        self.init()
        self.persistentContainer = persistentContainer
    }
    
    func fetchAllEpisodes(context: NSManagedObjectContext) -> [Episode] {
        
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        var storedEpisodes: [Episode]?
        do {
            storedEpisodes = try context.fetch(fetchRequest)
        } catch {
            return [Episode]()
        }
        
        return storedEpisodes!
    }
    
    func delete(episodes: [Episode], guidArray: [String], context: NSManagedObjectContext) throws {
        
        var deletedObjectIds = [NSManagedObjectID]()
        
        for episode in episodes {
            if guidArray.contains(episode.guid ?? "") {
                context.delete(episode)
                deletedObjectIds.append(episode.objectID)
            }
        }

        // save context
        do {
            try context.save()
        } catch {
            throw error
        }
        
        // notify changes
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey:deletedObjectIds], into: [self.persistentContainer.viewContext])
    }
    
    func update(episodes: [Episode], episodeTuples: [EpisodeFeedTuple], context: NSManagedObjectContext) throws {
        
        var updatedObjectIds = [NSManagedObjectID]()
        for episode in episodes {
            
            let updatePair = episodeTuples.filter{$0.guid == (episode.guid ?? "")}
            
            if let updatePair = updatePair.first {
                episode.desc = updatePair.desc
                episode.fileSize = updatePair.fileSize
                episode.link = updatePair.link
                episode.pubDate = updatePair.pubDate as NSDate
                episode.title = updatePair.title
                
                updatedObjectIds.append(episode.objectID)
            }
        }
        
        // save context
        do {
            try context.save()
        } catch {
            throw error
        }
        
        // notify changes
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey:updatedObjectIds],into: [self.persistentContainer.viewContext])
        
    }
    
    func insertEpisodes(episodeTuples: [EpisodeFeedTuple], to show:Show, context: NSManagedObjectContext) throws {
        
        _ = self.episodes(episodeTuples: episodeTuples, to: show, context: context)
        
        // save context
        do {
            try context.save()
        } catch {
            throw error
        }
        
    }
    
    private func episodes(episodeTuples: [EpisodeFeedTuple], to show:Show, context:NSManagedObjectContext) -> [Episode] {
        
        var episodes = [Episode]()
        
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
            
            episodes.append(episode)
        }
        
        return episodes
    }
    
    func insertShow(showTuple: ShowFeedTuple, episodeTuples: [EpisodeFeedTuple], rssFeedUrl: URL, context: NSManagedObjectContext) throws {
        
        let show = Show(context: context)

        // feed properties
        show.title = showTuple.title
        show.desc = showTuple.desc
        show.language = showTuple.language
        show.link = showTuple.link
        show.rssFeedUrl = rssFeedUrl.absoluteString
        
        // TODO: - asynchronously
        if let url = URL(string: showTuple.logoImageUrlString),
            let data = try? Data(contentsOf: url) as NSData {
            show.logoImage = data
        }

        show.pubDate = showTuple.pubDate as NSDate
        _ = self.episodes(episodeTuples: episodeTuples, to: show, context: context)

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
    
    func fetchShow(rssFeedUrl: String, context: NSManagedObjectContext) -> Show? {
        
        // TODO: - test code needed
        let fetchRequest = Show.fetchRequest(rssFeedUrl: rssFeedUrl)
        var storedShows: [Show]?
        do {
            storedShows = try context.fetch(fetchRequest)
        } catch {
            return nil
        }
        
        return storedShows?.first
    }
    
    func fetchAllShows(context: NSManagedObjectContext) -> [Show] {
        
        let fetchRequest: NSFetchRequest<Show> = Show.fetchRequest()
        var storedShows: [Show]?
        do {
            storedShows = try context.fetch(fetchRequest)
        } catch {
            return [Show]()
        }
        
        return storedShows!
        
    }
}
