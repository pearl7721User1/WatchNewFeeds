//
//  EpisodePuller.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

class EpisodePuller: NSObject {
    
    private let feedPullOperation: FeedPullOperation
    @objc private var queue: OperationQueue = OperationQueue()
    private var observationForQueue: NSKeyValueObservation?
    
    typealias FeedPullerCompletion = (_ show: [String:Any]?, _ episodes: [[String:Any]]) -> Void
    
    init(feedURL: URL) {
        self.feedPullOperation = FeedPullOperation(feedUrl: feedURL)
    }
    
    func pull(completion:@escaping FeedPullerCompletion) {
        
        self.observationForQueue = observe(\.queue.operationCount,
                                           options: [.new], changeHandler:
            { object, change in
                
                if (change.newValue == 0) {
                    
                    completion(self.feedPullOperation.show, self.feedPullOperation.episodes)
                }
        })
        
        queue.addOperation(feedPullOperation)
        
    }
    
    
}
