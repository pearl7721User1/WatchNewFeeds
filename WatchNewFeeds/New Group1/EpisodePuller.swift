//
//  EpisodePuller.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class EpisodePuller {
    
    private let feedURL: String
    private let episodeFetchOperation: EpisodeFetchOperation
//    private let episodeFeedPullOperation: EpisodeFeedPullOperation
    
    typealias EpisodePullerCompletion = (Error?, [Episode]?, [[String:Any]]?) -> Void
    
    enum EpisodePullerError: Error {
        case failedToPullFeeds
        case failedToPullStoredEpisodes
        case failedCompletely
        case unknown
    }
    
    init(coreDataStack: CoreDataStack, feedURL: String) {
        self.feedURL = feedURL
        
        let backgroundContext = coreDataStack.persistentContainer.newBackgroundContext()
        self.episodeFetchOperation = EpisodeFetchOperation(context: backgroundContext, coreDataStack: coreDataStack)
        
        
    }
    
    
    func pull(completion:EpisodePullerCompletion) {
        
    }
    
    
}
