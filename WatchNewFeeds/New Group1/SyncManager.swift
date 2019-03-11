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

    private var coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext
    
    var episodePuller: EpisodePuller
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack, feedURL: URL) {
        
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
        self.episodePuller = EpisodePuller(feedURL: feedURL)
    }
    
    func sync() {
        
        guard let episodes = try? coreDataStack.fetchAllEpisodes(context: context) else {
            // TODO: - report error
            
            return
        }
        
        episodePuller.pull(completion: { (showTuple, episodeTuples) in
            
            let comparatorResult = self.episodeComparator.compare(episodes: episodes, episodeTuples: episodeTuples)
            self.handle(result: comparatorResult)
            
        })
    }
    
    private func handle(result: EpisodeComparatorResult) {
        
        try? self.coreDataStack.deleteEpisodes(guidArray: result.deleteRequired, context: self.context)
        try? self.coreDataStack.updateEpisodes(episodeTuples: result.updateRequired, context: self.context)
        try? self.coreDataStack.insertEpisodes(episodeTuples: result.insertRequired, context: self.context)
    }
}
