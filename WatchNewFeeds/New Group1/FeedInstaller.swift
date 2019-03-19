//
//  FeedInstaller.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 16/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData


class FeedInstaller {

    private let feedUrl: URL
    var coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    private let feedPuller: FeedPuller
    
    init(feedUrl: URL, coreDataStack: CoreDataStack) {
        self.feedUrl = feedUrl
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
        self.feedPuller = FeedPuller(feedURL: feedUrl)
    }
    
    func doesFeedExist() -> Bool {

        guard let mightBeShow = try? coreDataStack.fetchShow(rssFeedUrl: feedUrl.absoluteString, context: context) else {
            return false
        }
        
        return mightBeShow != nil ? true : false
    }
    
    func installFeed(completion:@escaping ((_ finished: Bool) -> Void)) {
        
        feedPuller.pull { (showTuple: ShowTuple?, episodeTuples: [EpisodeTuple]) in
            
            if let showTuple = showTuple,
                let show = self.coreDataStack.insertShow(showTuple: showTuple, context: self.context) {
                
                var finished = true
                do {
                    try self.coreDataStack.insertEpisodes(episodeTuples: episodeTuples, to: show, context: self.context)
                } catch {
                    finished = false
                }
                
                completion(finished)
            }
            
        }
        
        
    }
    
}
