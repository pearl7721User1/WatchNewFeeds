//
//  MockFeedPuller.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 30/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
@testable import WatchNewFeeds

class MockFeedPuller: NSObject, FeedPullable {
    
    func pull(completion: @escaping ([FeedPullResult]) -> Void) {
    
        let feedPullResult = [feedPullResult1(), feedPullResult2()]
        completion(feedPullResult)
    }
    
}

private func feedPullResult1() -> FeedPullResult {
    let show: ShowFeedTuple = ("Show1Desc", "KR", "Link", "sampleString", Date(timeIntervalSince1970: 4000), "Show1")
    let episode1: EpisodeFeedTuple = ("Show1Episode1Desc", 1234, "guid1", "Link", Date(timeIntervalSince1970: 4000), "show1episode1")
    let episode2: EpisodeFeedTuple = ("Show1Episode2Desc", 1234, "guid2", "Link", Date(timeIntervalSince1970: 4000), "show1episode2")
    
    return FeedPullResult.init(show: show, episodes: [episode1, episode2])
}

private func feedPullResult2() -> FeedPullResult {
    let show: ShowFeedTuple = ("Show2Desc", "KR", "Link", "sampleString", Date(timeIntervalSince1970: 4000), "Show2")
    let episode1: EpisodeFeedTuple = ("Show2Episode1Desc", 1234, "guid1", "Link", Date(timeIntervalSince1970: 4000), "show2episode1")
    let episode2: EpisodeFeedTuple = ("Show2Episode2Desc", 1234, "guid2", "Link", Date(timeIntervalSince1970: 4000), "show2episode2")
    
    return FeedPullResult.init(show: show, episodes: [episode1, episode2])
}
