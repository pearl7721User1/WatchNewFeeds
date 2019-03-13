//
//  SyncManagerTests.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import XCTest
import CoreData

@testable import WatchNewFeeds

class SyncManagerTests: XCTestCase {

    var syncManager: SyncManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
        let coreDataStack = CoreDataStack(with: mockContainer)
//        self.syncManager = SyncManager.init(coreDataStack: coreDataStack, feedURL: "abc")
        
    }
    
}
