//
//  EpisodePuller.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

protocol FeedPullable {
    func pull(completion:@escaping (_ feedPullResult: [FeedPullResult]) -> Void)
}

class FeedPuller: NSObject, FeedPullable {
    
    private let feedPullOperations: [FeedPullOperation]
    @objc private var queue: OperationQueue = OperationQueue()
    private var observationForQueue: NSKeyValueObservation?
    
    init(feedUrls: [URL]) {
        self.feedPullOperations = feedUrls.map{FeedPullOperation(feedUrl: $0)}
    }
    
    func pull(completion:@escaping (_ feedPullResult: [FeedPullResult]) -> Void) {
        
        self.observationForQueue = observe(\.queue.operationCount,
                                           options: [.new], changeHandler:
            { object, change in
                
                if (change.newValue == 0) {
                    
                    let results = self.feedPullOperations.map{FeedPullResult(show: $0.showTuple, episodes: $0.episodeTuples, feedRssUrl: $0.feedUrl)}
                    
                    
                    completion(results)
                }
        })
        
        queue.addOperations(feedPullOperations, waitUntilFinished: false)
        
    }
    
    
}

struct FeedPullResult {
    let show: ShowFeedTuple?
    let episodes: [EpisodeFeedTuple]
    let feedRssUrl: URL
}
