//
//  EpisodeComparatorTests.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 12/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import XCTest
import CoreData

@testable import WatchNewFeeds

class EpisodeComparatorTests: XCTestCase {

    var sut = EpisodeComparator()
    
    var coreDataStack: CoreDataStack!
    var backgroundContext: NSManagedObjectContext!
    var episodes: [Episode]!
    
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
        self.coreDataStack = CoreDataStack(with: mockContainer)
        self.backgroundContext = coreDataStack.persistentContainer.newBackgroundContext()
        
        insertEpisodebase()
        
        guard let theEpisodes = try? coreDataStack.fetchAllEpisodes(context: self.backgroundContext) else {
            XCTFail()
            return
        }
        
        self.episodes = theEpisodes
    }
    
    private func insertEpisodebase() {
        
        // insert sample episodes
        let feedEpisodeDictArray = EpisodeSampleFactory.sampleFeedEpisodesForJan2018()
        let episodeTuples = feedEpisodeDictArray.flatMap{ try? Episode.deserialized(dict: $0) }
        
        guard (try? coreDataStack.insertEpisodes(episodeTuples: episodeTuples, context: self.backgroundContext)) != nil else {
            XCTFail()
            return
        }
        
    }
    
    
    
    func testDeleteAndInsertRequired() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let episodeDictArray = EpisodeSampleFactory.sampleFeedEpisodesForApr2018()
        let episodeTuples = episodeDictArray.flatMap{ try? Episode.deserialized(dict: $0) }
        
        let result = sut.compare(episodes: self.episodes, episodeTuples: episodeTuples)
        
        XCTAssert(result.deleteRequired.count == 2)
        XCTAssert(result.updateRequired.count == 0)
        XCTAssert(result.insertRequired.count == 2)
        
    }

    func testInsertRequired() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let episodeDictArray = EpisodeSampleFactory.sampleFeedEpisodesForMar2018()
        let episodeTuples = episodeDictArray.flatMap{ try? Episode.deserialized(dict: $0) }
        
        let result = sut.compare(episodes: self.episodes, episodeTuples: episodeTuples)
        
        XCTAssert(result.deleteRequired.count == 0)
        XCTAssert(result.updateRequired.count == 0)
        XCTAssert(result.insertRequired.count == 2)
        
    }
    
    func testUpdateRequired() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let episodeDictArray = EpisodeSampleFactory.sampleFeedEpisodesForFeb2018()
        let episodeTuples = episodeDictArray.flatMap{ try? Episode.deserialized(dict: $0) }
        
        let result = sut.compare(episodes: self.episodes, episodeTuples: episodeTuples)
        
        XCTAssert(result.deleteRequired.count == 0)
        XCTAssert(result.updateRequired.count == 5)
        XCTAssert(result.insertRequired.count == 0)
        
    }

}
