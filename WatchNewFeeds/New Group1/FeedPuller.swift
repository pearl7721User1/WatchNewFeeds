//
//  EpisodePuller.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class FeedPuller: NSObject {
    
    private let feedPullOperation: FeedPullOperation
    @objc private var queue: OperationQueue = OperationQueue()
    private var observationForQueue: NSKeyValueObservation?
    
    typealias FeedPullerCompletion = (_ show: ShowTuple?, _ episodes: [EpisodeTuple]) -> Void
    
    init(feedURL: URL) {
        self.feedPullOperation = FeedPullOperation(feedUrl: feedURL)
    }
    
    func pull(completion:@escaping FeedPullerCompletion) {
        
        self.observationForQueue = observe(\.queue.operationCount,
                                           options: [.new], changeHandler:
            { object, change in
                
                if (change.newValue == 0) {
                    
                    completion(self.feedPullOperation.showTuple, self.feedPullOperation.episodeTuples)
                }
        })
        
        queue.addOperation(feedPullOperation)
        
    }
    
    
}
