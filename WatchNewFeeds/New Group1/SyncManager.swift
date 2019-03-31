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

    // TODO: - show conforms a protocol
    private var coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext
    
//    var feedPuller: FeedPuller?
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack) {
        
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
    }
    
    func sync() {
        // fetch all shows
        let installedShows = self.coreDataStack.fetchAllShows(context: context)
        
        for (_, installedShow) in installedShows.enumerated() {
            
            sync(for: installedShow) { (feedPullResults: [FeedPullResult]?) in
                
                if let feedPullResults = feedPullResults,
                    let firstPullResult = feedPullResults.first,
                    let _ = firstPullResult.show,
                    let episodes = installedShow.episodes as? Set<Episode> {
                    
                    let comparatorResult = self.episodeComparator.compare(episodes: Array(episodes), episodeTuples: firstPullResult.episodes)
                    
                    self.handle(result: comparatorResult, show: installedShow)
                }
            }
        }
        
    }
    
    private func sync(for show:Show, completion: @escaping ((_ feedPullResult: [FeedPullResult]?) -> Void)) {
        
        if let rssFeedUrl = URL(string:show.rssFeedUrl ?? "") {
            let feedPuller = FeedPuller(feedUrls: [rssFeedUrl])
            feedPuller.pull(completion: completion)
        } else {
            completion(nil)
        }
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
