//
//  Episode+CoreDataProperties.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }
    
    @nonobjc public class func fetchRequest(guid: String) -> NSFetchRequest<Episode> {
        
        let fetchRequest = NSFetchRequest<Episode>(entityName: "Episode")
        fetchRequest.predicate = NSPredicate(format: "guid == %@", guid)
        return fetchRequest
    }

    @NSManaged public var desc: String?
    @NSManaged public var fileSize: Int64
    @NSManaged public var guid: String?
    @NSManaged public var link: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var show: Show?

}
