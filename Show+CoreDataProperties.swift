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

typealias ShowFeedTuple = (desc: String, language: String, link: String, logoImageUrlString: String, pubDate: Date, title: String)

extension Show {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Show> {
        return NSFetchRequest<Show>(entityName: "Show")
    }
    
    @nonobjc public class func fetchRequest(rssFeedUrl: String) -> NSFetchRequest<Show> {
        
        let fetchRequest = NSFetchRequest<Show>(entityName: "Show")
        fetchRequest.predicate = NSPredicate(format: "rssFeedUrl == %@", rssFeedUrl)
        return fetchRequest
    }

    @NSManaged public var rssFeedUrl: String?
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
    
    
    
    enum error: Error {
        case DeserializationFail
    }
    
    
    class func serialized(desc: String, language: String, link: String, logoImageUrlString: String, pubDate: Date, title: String) -> [String: Any] {
        
        let showDict: [String: Any] = ["desc": desc,
                                          "language": language,
                                          "link": link,
                                          "logoImageUrlString": logoImageUrlString,
                                          "pubDate": pubDate,
                                          "title": title]
        return showDict
    }
    
    class func deserialized(dict: [String: Any]) throws -> ShowFeedTuple {
        
        if let desc = dict["desc"] as? String,
            let language = dict["language"] as? String,
            let link = dict["link"] as? String,
            let logoImageUrlString = dict["logoImageUrlString"] as? String,
            let pubDate = dict["pubDate"] as? Date,
            let title = dict["title"] as? String {
            
            return (desc: desc, language: language, link: link, logoImageUrlString: logoImageUrlString, pubDate: pubDate, title: title)
        }
        
        throw Show.error.DeserializationFail
    }
    
}
