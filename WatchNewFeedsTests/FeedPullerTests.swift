//
//  FeedPullOperationTests.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 13/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import XCTest
import CoreData

@testable import WatchNewFeeds


class FeedPullerTests: XCTestCase {

    var feedPuller = FeedPuller(feedUrls: FeedInstaller.sampleFeedUrls())
    
    func testPull() {
        
        let expectation = XCTestExpectation(description: "pull operation")
        
        self.feedPuller.pull(completion: { (feedPullResults: [FeedPullResult]) in
            XCTAssert(feedPullResults.count == FeedInstaller.sampleFeedUrls().count)
            expectation.fulfill()
        })
        
        
        wait(for: [expectation], timeout: 10.0)
    }

}
