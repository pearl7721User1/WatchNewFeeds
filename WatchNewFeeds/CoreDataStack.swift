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
    
    func addEpisodes(dictArray: [[String:Any]], context: NSManagedObjectContext) {
        
        // iterate, parse dictionary
        /*
         // M
         @NSManaged public var title: String?
         @NSManaged public var desc: String?
         @NSManaged public var link: String?
         @NSManaged public var guid: String?
         @NSManaged public var pubDate: NSDate?
         @NSManaged public var fileSize: Int16
         @NSManaged public var show: Show?
         
 */
        for (_,v) in dictArray.enumerated() {
            guard let title = v["title"] as? String,
                let desc = v["desc"] as? String,
            let link = v["link"] as? String,
            let guid = v["guid"] as? String,
            let pubDateString = v["pubDate"] as? String,
                let fileSize = v["fileSize"] as? Int64 else {
                
                print("\(v.description) is not a valid dictionary")
                continue
            }
            
            // create a episode nsmanabed object
            let episode = Episode(context: context)
            
            // feed properties
            episode.title = title
            episode.desc = desc
            episode.link = link
            episode.guid = guid
            episode.pubDate = Date() as NSDate
            episode.fileSize = fileSize
            
        }
        
        // save context
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func updateEpisodes(dictArray: [[String:Any]], context: NSManagedObjectContext) {
        
        // fetch one by one by guid to create an in-memory nsmanaged object
        for (_,v) in dictArray.enumerated() {
            guard let title = v["title"] as? String,
                let desc = v["desc"] as? String,
                let link = v["link"] as? String,
                let guid = v["guid"] as? String,
                let pubDateString = v["pubDate"] as? String,
                let fileSize = v["fileSize"] as? Int64 else {
                    
                    print("\(v.description) is not a valid dictionary")
                    continue
            }
        
            let fetchRequest = Episode.fetchRequest(guid: guid)
            var episode: Episode?
            do {
                let fetchResult = try context.fetch(fetchRequest)
                
                if fetchResult.count != 1 {
                    print("guid:\(guid) is more than one or has not been found")
                    continue
                }
                
                episode = fetchResult.first
                
            } catch {
                print(error.localizedDescription)
                continue
            }
        
            // update nsmanaged object
            episode?.title = title
            episode?.desc = desc
            episode?.link = link
            episode?.guid = guid
            episode?.pubDate = Date() as NSDate
            episode?.fileSize = fileSize
            
        }
        
        // save context
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
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
