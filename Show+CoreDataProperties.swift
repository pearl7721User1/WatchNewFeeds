//
//  Show+CoreDataProperties.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//
//

import Foundation
import CoreData


extension Show {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Show> {
        return NSFetchRequest<Show>(entityName: "Show")
    }

    @NSManaged public var desc: String?
    @NSManaged public var language: String?
    @NSManaged public var link: String?
    @NSManaged public var logoImage: NSData?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var episodes: NSSet?

}

// MARK: Generated accessors for episodes
extension Show {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}
