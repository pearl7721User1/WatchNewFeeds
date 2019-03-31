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
    private let coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    private var feedPuller: FeedPullable?
    
    init(feedUrls: [URL], coreDataStack: CoreDataStack, feedPuller: FeedPullable? = nil) {
        self.feedUrls = feedUrls
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
        self.feedPuller = feedPuller
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
        
        let theFeedPuller = feedPuller != nil ? feedPuller : FeedPuller.init(feedUrls: [url])
        
        theFeedPuller!.pull(completion: {(feedPullResults: [FeedPullResult]) in
            
            
            if let feedPullResult = feedPullResults.first {
                
                if let showFeedTuple = feedPullResult.show,
                    let show = self.coreDataStack.insertShow(showTuple: showFeedTuple, rssFeedUrl: url, context: self.context) {
                    
                    var finished = true
                    do {
                        try self.coreDataStack.insertEpisodes(episodeTuples: feedPullResult.episodes, to: show, context: self.context)
                    } catch {
                        finished = false
                    }
                    
                    completion(finished)
                }
            }
        })
    }    
    
    static func sampleFeedUrls() -> [URL] {
        let allEarsEnglish: URL = URL(string:"http:allearsenglish.libsyn.com/rss")!
        let englishWeSpeak: URL = URL(string:"https://podcasts.files.bbci.co.uk/p02pc9zn.rss")!
        let globalNews: URL = URL(string:"https://podcasts.files.bbci.co.uk/p02nq0gn.rss")!
        let bbcEnglishDrama: URL = URL(string:"https://podcasts.files.bbci.co.uk/p02pc9s1.rss")!
        
        return [allEarsEnglish, englishWeSpeak, globalNews, bbcEnglishDrama]
    }
}
