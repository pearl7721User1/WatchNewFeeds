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

typealias EpisodePropertiesTuple = (desc: String, fileSize: Double, guid: String, link: String, pubDate: Date, title: String)

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
    @NSManaged public var fileSize: Double
    @NSManaged public var guid: String?
    @NSManaged public var link: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var show: Show?
    
    
    enum error: Error {
        case DeserializationFail
    }
    

    class func serialized(desc: String, fileSize: Double, guid: String, link: String, pubDate: Date, title: String) -> [String: Any] {
        
        let episodeDict: [String: Any] = ["title": title,
                                             "desc": desc,
                                             "link": link,
                                             "guid": guid,
                                             "pubDate": pubDate,
                                             "fileSize": fileSize]
        return episodeDict
    }
    
    class func deserialized(dict: [String: Any]) throws -> EpisodePropertiesTuple {
        
        if let title = dict["title"] as? String,
            let desc = dict["desc"] as? String,
            let link = dict["link"] as? String,
            let guid = dict["guid"] as? String,
            let pubDate = dict["pubDate"] as? Date,
            let fileSize = dict["fileSize"] as? Double {
                
                return (desc: desc, fileSize: fileSize, guid: guid, link: link, pubDate: pubDate, title: title)
        }
        
        throw Episode.error.DeserializationFail
    }
    
    class func isEqualProperties(episode: Episode, dict: [String: Any]) -> Bool {
        
        guard let lvTitle = episode.title,
            let lvDesc = episode.desc,
            let lvLink = episode.link,
            let lvGuid = episode.guid,
            let lvPubDate = episode.pubDate,
            let rvTitle = dict["title"] as? String,
            let rvDesc = dict["desc"] as? String,
            let rvLink = dict["link"] as? String,
            let rvGuid = dict["guid"] as? String,
            let rvPubDate = dict["pubDate"] as? Date,
            let rvFileSize = dict["fileSize"] as? Double else {
                return false
        }
        let lvFileSize = episode.fileSize
        
        if lvTitle == rvTitle, lvDesc == rvDesc, lvLink == rvLink, lvGuid == rvGuid, lvPubDate as Date == rvPubDate, lvFileSize == rvFileSize {
            return true
        } else {
            return false
        }
    }
}
