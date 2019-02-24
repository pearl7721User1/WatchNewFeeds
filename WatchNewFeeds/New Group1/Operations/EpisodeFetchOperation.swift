//
//  EpisodeFetchOperation.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 22/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class EpisodeFetchOperation: Operation {

    private let context: NSManagedObjectContext
    private let coreDataStack: CoreDataStack
    private var episodes: [Episode]?
    
    init(context: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.context = context
        self.coreDataStack = coreDataStack
    }
    
    override func main() {
        self.episodes = try? coreDataStack.fetchAllEpisodes(context: context)
    }
    
    func fetchedEpisodes() -> [Episode]? {        
        return episodes
    }
}
