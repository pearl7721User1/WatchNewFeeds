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
        
        episodePuller.pull(completion: { (show, episodesDictArray) in
            
            let comparatorResult = self.episodeComparator.compare(episodes: episodes, episodesDict: episodesDictArray)
            self.handle(result: comparatorResult)
            
        })
    }
    
    private func handle(result: EpisodeComparatorResult) {
        
        if let deleteRequired = result.deleteRequired {
            try? self.coreDataStack.deleteEpisodes(guidArray: deleteRequired, context: self.context)
        }
        
        if let updateRequired = result.updateRequired {
//            try? self.coreDataStack.updateEpisodes(episodePropertiesArray: updateRequired, context: self.context)
        }
        
        if let insertRequired = result.insertRequired {
//            try? self.coreDataStack.insertEpisodes(dictArray: insertRequired, context: self.context)
        }
        
    }
}
