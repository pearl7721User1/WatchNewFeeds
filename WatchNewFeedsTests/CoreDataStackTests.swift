//
//  WatchNewFeedsTests.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import XCTest
import CoreData

@testable import WatchNewFeeds

class CoreDataStackTests: XCTestCase {
    
    var sut: CoreDataStack!
    var backgroundContext: NSManagedObjectContext!
    var viewContext: NSManagedObjectContext!
    
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
        self.sut = CoreDataStack(with: mockContainer)
        self.backgroundContext = sut.persistentContainer.newBackgroundContext()
        self.viewContext = sut.persistentContainer.viewContext
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testInsertingEpisodes() {

        // insert sample episodes
        let feedEpisodesDictArray = sampleFeedEpisodes()
        let episodePropertiesTupleArray = feedEpisodesDictArray.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        self.insertEpisodes(episodePropertiesTupleArray: episodePropertiesTupleArray)
        
        // fetch episodes for comparison
        let guids = episodePropertiesTupleArray.map{$0.guid}
        let insertedEpisodes = self.insertedEpisodes(guids: guids)
        
        if (insertedEpisodes.count != feedEpisodesDictArray.count) || (insertedEpisodes.count < 1) {
            XCTFail()
        }
        
        for (i,insertedEpisode) in insertedEpisodes.enumerated() {
            
            let dict = feedEpisodesDictArray[i]
            if Episode.isEqualProperties(episode:insertedEpisode, dict:dict) == false {
                XCTFail()
            }
        }
    }
    
    func testUpdatingEpisodes() {
        
        // insert sample episodes
        let feedEpisodesDictArray = sampleFeedEpisodes()
        let episodePropertiesTupleArray = feedEpisodesDictArray.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        self.insertEpisodes(episodePropertiesTupleArray: episodePropertiesTupleArray)
        
        // update episodes
        let updates = sampleFeedEpisodes2()
        let updatesTupleArray = updates.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        self.updateEpisodes(episodePropertiesTupleArray: updatesTupleArray)
        
        // sum up
        let summedUpDictArray = self.summedUpDictArray(oldDictArray: feedEpisodesDictArray, updates: updates)
        let summedUpEpisodeTupleArray = summedUpDictArray.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        
        // fetch episodes for comparison
        let guids = summedUpEpisodeTupleArray.map{$0.guid}
        let insertedEpisodes = self.insertedEpisodes(guids: guids)
        
        if (insertedEpisodes.count != summedUpDictArray.count) || (insertedEpisodes.count < 1) {
            XCTFail()
        }
        
        for (i,insertedEpisode) in insertedEpisodes.enumerated() {
            
            let dict = summedUpDictArray[i]
            if Episode.isEqualProperties(episode:insertedEpisode, dict:dict) == false {
                XCTFail()
            }
        }
    }
    
    func testUpdatingEpisodesWithWrongGuidsThrowError() {
        
        // insert sample episodes
        let feedEpisodesDictArray = sampleFeedEpisodes()
        let episodePropertiesTupleArray = feedEpisodesDictArray.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        self.insertEpisodes(episodePropertiesTupleArray: episodePropertiesTupleArray)
        
        // update episodes
        let updates = sampleFeedEpisodes2()
        var updatesTupleArray = updates.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        
        let numOfWrongGuids = 1
        let wrongGuid = "1"
        var isErrorThrown = false
        
        updatesTupleArray[0].guid = wrongGuid
        
        do {
            try sut.updateEpisodes(episodePropertiesTupleArray: updatesTupleArray, context: self.backgroundContext)
            
        } catch {
            
            if case let CoreDataStack.error.executionError(guids) = error {
                
                XCTAssertTrue(guids.count == numOfWrongGuids)
                XCTAssertTrue(guids[0] == wrongGuid)
                
                isErrorThrown = true
            }
            
        }
        
        XCTAssertTrue(isErrorThrown == true)
    }
    
    func testDeletingAllEpisodes() {
        // insert sample episodes
        let feedEpisodesDictArray = sampleFeedEpisodes()
        let episodePropertiesTupleArray = feedEpisodesDictArray.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        self.insertEpisodes(episodePropertiesTupleArray: episodePropertiesTupleArray)
        
        let guids = episodePropertiesTupleArray.map{$0.guid}
        
        do {
            try sut.deleteEpisodes(guidArray: guids, context: self.backgroundContext)
        } catch {
            XCTFail()
        }
        
        // fetch episodes for comparison
        let insertedEpisodes = self.insertedEpisodes(guids: guids)
        
        if (insertedEpisodes.count > 0) {
            XCTFail()
        }
        
    }
    
    
    
    private func insertedEpisodes(guids: [String]) -> [Episode] {
        
        var insertedEpisodes = [Episode]()
        
        for (_,guid) in guids.enumerated() {
            let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest(guid: guid)
            do {
                let fetchResult = try self.viewContext.fetch(fetchRequest)
                if let first = fetchResult.first {
                    insertedEpisodes.append(first)
                }
                
            } catch {
                XCTFail()
            }
        }
        
        return insertedEpisodes
    }
    
    private func insertEpisodes(episodePropertiesTupleArray: [EpisodeTuple]) {
        do {
            try sut.insertEpisodes(episodePropertiesTupleArray: episodePropertiesTupleArray, context: self.backgroundContext)
            
        } catch {
            XCTFail()
        }
    }
    
    private func updateEpisodes(episodePropertiesTupleArray: [EpisodeTuple]) {
        do {
            try sut.updateEpisodes(episodePropertiesTupleArray: episodePropertiesTupleArray, context: self.backgroundContext)
            
        } catch {
            XCTFail()
        }
    }
    
    private func summedUpDictArray(oldDictArray: [[String:Any]], updates:[[String:Any]]) -> [[String:Any]] {
        
        var destinationDictArray = oldDictArray
        
        let updatedPropertiesArray = updates.filter{ (try? Episode.deserialized(dict: $0)) != nil }.map{try! Episode.deserialized(dict: $0)}
        let updatedGuids = updatedPropertiesArray.map{$0.guid}
        
        for (_,updatedGuid) in updatedGuids.enumerated() {
            
            let updatedProperties = updates.filter{$0["guid"] as! String == updatedGuid}[0]
            var theEntry = destinationDictArray.filter{($0["guid"] as! String) == updatedGuid}[0]
            
            theEntry["title"] = updatedProperties["title"]
            theEntry["desc"] = updatedProperties["desc"]
            theEntry["link"] = updatedProperties["link"]
            theEntry["pubDate"] = updatedProperties["pubDate"]
            theEntry["fileSize"] = updatedProperties["fileSize"]
            
            var indexOfInterest: Int = 0
            for (j,u) in destinationDictArray.enumerated() {
                if (u["guid"] as! String) == updatedGuid {
                    indexOfInterest = j
                }
            }
            
            destinationDictArray[indexOfInterest] = theEntry
        }
        
        return destinationDictArray
    }
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}

extension CoreDataStackTests {
    func sampleFeedEpisodes() -> [[String:Any]] {
        
        let sampleEpisode1 = Episode.serialized(desc: "The Simpsons goes to see the quack", fileSize: Double(12356), guid: "7987239841", link: "https://www.roastingFire.com", pubDate: Date(), title: "Roasting Fire")
        
        let sampleEpisode2 = Episode.serialized(desc: "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare", fileSize: Double(123455), guid: "2341928", link: "https://www.lisaGotBraces.com", pubDate: Date(), title: "Lisa got braces")
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "12342431", link: "https://www.bartGoesToSchool.com", pubDate: Date(), title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "7652374", link: "https://www.HauntedTheater.com", pubDate: Date(), title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "865326341", link: "https://www.mysteryBookstore.com", pubDate: Date(), title: "The mystery bookstore")
        
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5]
        
    }
    
    func sampleFeedEpisodes2() -> [[String:Any]] {
        
        let sampleEpisode3 = Episode.serialized(desc: "BART CHEATS ON IQ TEST", fileSize: Double(9134), guid: "12342431", link: "https://www.bartGoesToSchool.com", pubDate: Date(), title: "BART GOES TO SCHOOL")
        
        let sampleEpisode4 = Episode.serialized(desc: "THE GHOSTS IN THE THEATER TURNS OUT TO BE A MADE UP", fileSize: Double(2341), guid: "7652374", link: "https://www.HauntedTheater.com", pubDate: Date(), title: "THE HAUNTED THEATER")
        
        return [sampleEpisode3, sampleEpisode4]
    }
}
