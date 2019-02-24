//
//  EpisodeFeedPullOperation.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 22/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import FeedKit

class EpisodeFeedPullOperation: Operation {

    private var rssFeed: [String: Any]?
    private var error: Error?
    
    // MARK: CunCurrency
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    
    
    override func start() {
        
        executing(true)
        
        let feedURL = URL.init(string: "http://allearsenglish.libsyn.com/rss")!
        let parser = FeedParser(URL: feedURL)
        
        
        // Parse asynchronously, not to block the UI.
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) {(result) in
            // Do your thing, then back to the Main thread
            self.error = result.error
            
            
            if let rssFeed = result.rssFeed,
                let items = rssFeed.items {
                
                let showDict = self.showElements(from: rssFeed)
                let episodeDictArray = self.episodeElements(from: items)
                
                // for future considerations
                if episodeDictArray.count != items.count {
                    print("what happend?")
                }
                
                // validation
                if let showDict = showDict {
                    
                    var rssFeed = [String: Any]()
                    
                    for (key, value) in showDict {
                        rssFeed.updateValue(value, forKey: key)
                    }
                    
                    rssFeed["episodes"] = episodeDictArray
                    
                    self.rssFeed = rssFeed
                }
                
            }
            
            self.executing(false)
            self.finish(true)
        }
        
        
    }
    
    private func showElements(from rssFeed: RSSFeed) -> [String: Any]? {
        
        guard let title = rssFeed.title,
            let description = rssFeed.description,
            let link = rssFeed.link,
            let pubDate = rssFeed.pubDate,
            let logoImage = rssFeed.image,
            let logoImageUrlString = logoImage.url else {
                
                return nil
        }
        
        
        
        var show = [String: Any]()
        show["title"] = title
        show["description"] = description
        show["link"] = link
        show["pubDate"] = pubDate
        show["logoImageUrl"] = logoImageUrlString
        
        return show
    }
    
    private func episodeElements(from rssFeedItems: [RSSFeedItem]) -> [[String: Any]] {
        
        var episodes = [[String: Any]]()
        
        for rssFeedItem in rssFeedItems {
            
            guard let title = rssFeedItem.title,
                let description = rssFeedItem.description,
                let itemGuid = rssFeedItem.guid,
                let guid = itemGuid.value,
                let pubDate = rssFeedItem.pubDate,
                let link = rssFeedItem.link,
                let iTunes = rssFeedItem.iTunes,
                let fileSize = iTunes.iTunesDuration else {
                    continue
            }
            
            let episodeDict = Episode.serialized(desc: description, fileSize: fileSize, guid: guid, link: link, pubDate: pubDate, title: title)
            
            episodes.append(episodeDict)
        }

        return episodes
    }
}
