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
    private let shows: [Show]
    private var coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext
    
    var feedPuller: FeedPuller?
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack, shows: [Show]) {
        
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
        self.shows = shows
        
        if let rssFeedUrlString = show.rssFeedUrl,
            let rssFeedUrl = URL(string: show.rssFeedUrl) {
            self.feedPuller = FeedPuller(feedURL: rssFeedUrl)
        }
        
    }
    
    func sync(for show:Show) throws {
        
        let episodes = coreDataStack.fetchAllEpisodes(context: context)
        feedPuller.pull(completion: { (showTuple, episodeTuples) in
            
            let comparatorResult = self.episodeComparator.compare(episodes: episodes, episodeTuples: episodeTuples)
            self.handle(result : comparatorResult)
            
        })
    }
    
    private func handle(result: EpisodeComparatorResult) {
        
        try? self.coreDataStack.deleteEpisodes(guidArray: result.deleteRequired, context: self.context)
        try? self.coreDataStack.updateEpisodes(episodeTuples: result.updateRequired, context: self.context)
        try? self.coreDataStack.insertEpisodes(episodeTuples: result.insertRequired, to: <#Show#>, context: self.context)
    }
}
