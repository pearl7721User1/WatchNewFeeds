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

    var feedPuller: FeedPuller!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.feedPuller = FeedPuller(feedURL: URL(string:"http:allearsenglish.libsyn.com/rss")!)
        
    }

    func testPull() {
        
        let expectation = XCTestExpectation(description: "pull operation")
        
        self.feedPuller.pull { (showTuple: ShowTuple?, episodeTuples: [EpisodeTuple]) in
            
            
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
