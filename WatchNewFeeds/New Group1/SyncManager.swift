//
//  SyncManager.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class SyncManager {

//    private var coreDataStack: CoreDataStack
//    private let feedURL: String
    
    var episodePuller: EpisodePuller
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack, feedURL: String) {
        
        self.episodePuller = EpisodePuller(coreDataStack: coreDataStack, feedURL: feedURL)
    }
}
