//
//  SyncManager.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class SyncManager {

    enum error: Error {
        case invalidRssFeedUrl
    }
    
    // TODO: - show conforms a protocol
    private let shows: [Show]
    private var coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext
    
//    var feedPuller: FeedPuller?
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack, shows: [Show]) {
        
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
        self.shows = shows
        
    }
    
    private func sync(for shows:[Show], completion:(_ error: SyncManager.error?) -> Void) {
        
        
        // TODO: - errors
        //invalidRssFeedUrls(from: shows)
        let rssFeedUrls = shows.compactMap{$0.rssFeedUrl}.compactMap{URL(string:$0)}
        let feedPuller = FeedPuller(feedUrls: rssFeedUrls)
        
        feedPuller.pull(completion: { (feedPullResults: [FeedPullResult]) in
            
            
            /*
            
            
            for (i,feedPullResult) in feedPullResults.enumerated() {
                
                let comparatorResult = self.episodeComparator.compare(episodes: episodes, episodeTuples: episodeTuples)
                self.handle(result : comparatorResult, show:show)
                
            }
            */
            
            
        })
        
    }
    
    private func handle(result: EpisodeComparatorResult, show: Show) {
        
        try? self.coreDataStack.deleteEpisodes(guidArray: result.deleteRequired, context: self.context)
        try? self.coreDataStack.updateEpisodes(episodeTuples: result.updateRequired, context: self.context)
        try? self.coreDataStack.insertEpisodes(episodeTuples: result.insertRequired, to: show, context: self.context)
    }
    
    private func invalidRssFeedUrls(from shows:[Show]) -> [String] {
        
        var urlStrings = [String]()
        for (_,v) in shows.enumerated() {
            
            guard let rssFeedUrlString = v.rssFeedUrl,
                let _ = URL(string: rssFeedUrlString) else {
                    
                urlStrings.append(v.rssFeedUrl ?? "")
                continue
            }
        }
        return urlStrings
    }
    
}
