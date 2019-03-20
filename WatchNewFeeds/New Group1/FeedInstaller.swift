//
//  FeedInstaller.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 16/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData


class FeedInstaller {
    
    private let feedUrls: [URL]
    var coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    
    init(feedUrls: [URL], coreDataStack: CoreDataStack) {
        self.feedUrls = feedUrls
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
    }
    
    func installedFeeds() -> [URL] {
        let shows = coreDataStack.fetchAllShows(context: context)
        let urls = shows.compactMap{$0.rssFeedUrl}.compactMap{URL(string:$0)}

        return urls
    }
    
    func existingFeeds() -> [URL] {
        return feedUrls
    }
    
    func installFeed(url: URL, completion:@escaping ((_ finished: Bool) -> Void)) {
        
        let feedPuller = FeedPuller(feedURL: url)
        feedPuller.pull(completion: {(showFeedTuple: ShowFeedTuple?, episodeFeedTuples: [EpisodeFeedTuple]) in
            
            if let showFeedTuple = showFeedTuple,
                let show = self.coreDataStack.insertShow(showTuple: showFeedTuple, rssFeedUrl: url, context: self.context) {
                
                var finished = true
                do {
                    try self.coreDataStack.insertEpisodes(episodeTuples: episodeFeedTuples, to: show, context: self.context)
                } catch {
                    finished = false
                }
                
                completion(finished)
            }
        })
        
    }
    
    
    static func sampleFeedUrls() -> [URL] {
        let BaseFeedURL: URL = URL(string:"http:allearsenglish.libsyn.com/rss")!
        // TODO: - more feeds
        
        return [BaseFeedURL]
    }
}
