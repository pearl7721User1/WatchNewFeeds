//
//  FeedInstallerTests.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 30/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import XCTest
import CoreData

@testable import WatchNewFeeds

class FeedInstallerTests: XCTestCase {
    
    var sut: FeedInstaller!
    let feedUrls = FeedInstaller.sampleFeedUrls()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.sut = feedInstallerWithMocks()
    }

    func testInstallOneFeedAndFeedShouldBeFoundInCoreData() {
        
        XCTAssert(sut.installedFeeds().count <= 0)
        
        let expectation = XCTestExpectation(description: "feedInstallerTest")

        sut.installFeed(url: feedUrls[0]) { (finished) in
            
            if (finished) {
                XCTAssert(self.sut.installedFeeds().count > 0)
                expectation.fulfill()
            } else {
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    private func feedInstallerWithMocks() -> FeedInstaller {
        
        let mockContainer = NSPersistentContainer(name: "WatchNewFeeds")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockContainer.persistentStoreDescriptions = [description]
        mockContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if (error as NSError?) != nil {
                XCTFail()
            }
        })
        
        // mock persistent container
        let mockCoreDataStack = CoreDataStack(with: mockContainer)
        let mockFeedPuller = MockFeedPuller()
        
        return FeedInstaller(feedUrls: feedUrls, coreDataStack: mockCoreDataStack, feedPuller: mockFeedPuller)
    }
    
}
