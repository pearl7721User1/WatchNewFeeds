//
//  SyncManager.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class SyncManager {

    // TODO: - show conforms a protocol
    private var coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext
    
    var feedPuller: FeedPullable?
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack, feedPuller: FeedPullable? = nil) {
        
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
        self.feedPuller = feedPuller
    }
    
    func sync(completion: ((_ localNotificationRequest: UNNotificationRequest?) -> Void)?) {
        // fetch all shows
        let installedShows = self.coreDataStack.fetchAllShows(context: context)
        
        let rssFeedUrlStrings = installedShows.compactMap{$0.rssFeedUrl}
        let rssFeedUrls = rssFeedUrlStrings.compactMap{URL(string:$0)}
        
        if (feedPuller == nil) {
            feedPuller = FeedPuller(feedUrls: rssFeedUrls)
        }
        
        feedPuller!.pull { (feedPullResults: [FeedPullResult]) in
            
            for feedPullResult in feedPullResults {
                
                if let _ = feedPullResult.show,
                    let equalShowFromInstalled = self.show(from: installedShows, OfRssFeedUrl: feedPullResult.feedRssUrl.absoluteString),
                    let installedEpisodes = equalShowFromInstalled.episodes as? Set<Episode> {
                    
                    let pulledEpisodes = feedPullResult.episodes
                    
                    let comparatorResult = self.episodeComparator.compare(episodes: Array(installedEpisodes), episodeTuples: pulledEpisodes)
                    
                    print("\(equalShowFromInstalled.title) has pulled \(pulledEpisodes.count) episodes and is going to install \(comparatorResult.insertRequired.count)")
                    
                    let mightBeNotificationRequest = self.handle(result: comparatorResult, show: equalShowFromInstalled)
                    
                    if let completion = completion {
                        completion(mightBeNotificationRequest)
                    }                    
                }
                
            }
        }
        
    }
    
    private func show(from shows:[Show], OfRssFeedUrl rssFeedUrl: String) -> Show? {
        
        let show = shows.first(where: {$0.rssFeedUrl == rssFeedUrl})
        return show
    }
    
    private func handle(result: EpisodeComparatorResult, show: Show) -> UNNotificationRequest? {
        
        // TODO: - show<NSSet> to [Show] function needed
        if let episodes = show.episodes as? Set<Episode> {
            
//            try? self.coreDataStack.delete(episodes: Array(episodes), guidArray: result.deleteRequired, context: self.context)
            
//            try? self.coreDataStack.update(episodes: Array(episodes), episodeTuples: result.updateRequired, context: self.context)
            
            if let _ = try? self.coreDataStack.insertEpisodes(episodeTuples: result.insertRequired, to: show, context: self.context) {
                
                // send local notification
                
                let request = SyncManager.localNotificationRequest(updatedShowTitle: show.title ?? "", amongUpdatedEpisodesTitle: result.insertRequired.first?.title ?? "")
                return request
                
            }
        }
        
        return nil
    }
    
    static func localNotificationRequest(updatedShowTitle: String, amongUpdatedEpisodesTitle: String) -> UNNotificationRequest {
        
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Episode Updates"
        content.subtitle = updatedShowTitle
        content.body = "\(amongUpdatedEpisodesTitle) is now available."
        content.sound = UNNotificationSound.default()
        
        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:2.0, repeats: false)
        
        //create request to display
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
        
        return request
    }
}
