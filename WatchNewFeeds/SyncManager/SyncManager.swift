//
//  SyncManager.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class SyncManager {

    var coreDataStack: CoreDataStack
    var episodePuller = EpisodePuller()
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}
