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
    
//    var feedPuller: FeedPuller?
    var episodeComparator = EpisodeComparator()
    
    init(coreDataStack: CoreDataStack) {
        
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.newBackgroundContext()
    }
    
    func sync() {
        // fetch all shows
        let installedShows = self.coreDataStack.fetchAllShows(context: context)
        
        for (_, installedShow) in installedShows.enumerated() {
            
            sync(for: installedShow) { (feedPullResults: [FeedPullResult]?) in
                
                if let feedPullResults = feedPullResults,
                    let firstPullResult = feedPullResults.first,
                    let _ = firstPullResult.show,
                    let episodes = installedShow.episodes as? Set<Episode> {
                    
                    let comparatorResult = self.episodeComparator.compare(episodes: Array(episodes), episodeTuples: firstPullResult.episodes)
                    
                    print("\(firstPullResult.show?.title) for downloading \(comparatorResult.insertRequired.count) episodes out of \(episodes.count)")
                    
                    self.handle(result: comparatorResult, show: installedShow)
                }
            }
        }
        
    }
    
    private func sync(for show:Show, completion: @escaping ((_ feedPullResult: [FeedPullResult]?) -> Void)) {
        
        if let rssFeedUrl = URL(string:show.rssFeedUrl ?? "") {
            let feedPuller = FeedPuller(feedUrls: [rssFeedUrl])
            feedPuller.pull(completion: completion)
        } else {
            completion(nil)
        }
    }
    
    private func handle(result: EpisodeComparatorResult, show: Show) {
        
        // TODO: - show<NSSet> to [Show] function needed
        if let episodes = show.episodes as? Set<Episode> {
            
//            try? self.coreDataStack.delete(episodes: Array(episodes), guidArray: result.deleteRequired, context: self.context)
            
//            try? self.coreDataStack.update(episodes: Array(episodes), episodeTuples: result.updateRequired, context: self.context)
            
            if let _ = try? self.coreDataStack.insertEpisodes(episodeTuples: result.insertRequired, to: show, context: self.context) {
                
                // send local notification
                let center =  UNUserNotificationCenter.current()
                let request = SyncManager.localNotificationRequest(updatedShowTitle: show.title ?? "", amongUpdatedEpisodesTitle: result.insertRequired.first?.title ?? "")
                center.add(request, withCompletionHandler: nil)
            }
        }
        
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
