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

class WatchNewFeedsTests: XCTestCase {
    
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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // insert sample episodes to persistent store
        let episodesForAdding = sampleEpisodeDictForAdding()
        
        do {
            try sut.addEpisodes(dictArray: episodesForAdding, context: backgroundContext)
        } catch {
            XCTFail()
        }
        
        
        
        // match the two sets
        for (i,_) in episodesForAdding.enumerated() {
            
            let episodeForAdding = episodesForAdding[i]
            let guid = episodeForAdding["guid"] as! String
            
            // try fetching from persistent store
            let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest(guid: guid)
            var storedEpisodes: [Episode]!
            do {
                storedEpisodes = try self.viewContext.fetch(fetchRequest)
            } catch {
                XCTFail()
                return
            }
            
            XCTAssert(storedEpisodes.count == 1)
            
            let storedEpisode = storedEpisodes.first!
            
            XCTAssertTrue(storedEpisode.title! == episodeForAdding["title"] as! String, "lv:\(storedEpisode.title!), rv:\(episodeForAdding["title"] as! String)")
            XCTAssertTrue(storedEpisode.desc! == episodeForAdding["desc"] as! String, "lv:\(storedEpisode.desc!), rv:\(episodeForAdding["desc"] as! String)")
        }
    }
    
    func testUpdatingEpisodes() {
        
        // insert sample episodes to persistent store
        let episodesForAdding = sampleEpisodeDictForAdding()
        
        do {
            try sut.addEpisodes(dictArray: episodesForAdding, context: backgroundContext)
        } catch {
            XCTFail()
        }
        
        
        let episodesForUpdating = sampleEpisodeDictForUpdating()
        
        do {
            try sut.updateEpisodes(dictArray: episodesForUpdating, context: backgroundContext)
        } catch {
            XCTFail()
        }
        
        
        for (i,_) in episodesForUpdating.enumerated() {
            
            let episodeForUpdating = episodesForUpdating[i]
            let guid = episodeForUpdating["guid"] as! String
            
            // try fetching from persistent store
            let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest(guid: guid)
            var storedEpisodes: [Episode]!
            do {
                storedEpisodes = try self.viewContext.fetch(fetchRequest)
            } catch {
                XCTFail()
                return
            }
            
            XCTAssert(storedEpisodes.count == 1)
            
            let storedEpisode = storedEpisodes.first!
            
            XCTAssertTrue(storedEpisode.title! == episodeForUpdating["title"] as! String, "lv:\(storedEpisode.title!), rv:\(episodeForUpdating["title"] as! String)")
            XCTAssertTrue(storedEpisode.desc! == episodeForUpdating["desc"] as! String, "lv:\(storedEpisode.desc!), rv:\(episodeForUpdating["desc"] as! String)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}

extension WatchNewFeedsTests {
    func sampleEpisodeDictForAdding() -> [[String:Any]] {
        
        let sampleEpisode1 = Episode.serialized(desc: "The Simpsons goes to see the quack", fileSize: Double(12356), guid: "7987239841", link: "https://www.roastingFire.com", pubDate: Date(), title: "Roasting Fire")
        
        let sampleEpisode2 = Episode.serialized(desc: "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare", fileSize: Double(123455), guid: "2341928", link: "https://www.lisaGotBraces.com", pubDate: Date(), title: "Lisa got braces")
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "12342431", link: "https://www.bartGoesToSchool.com", pubDate: Date(), title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "7652374", link: "https://www.HauntedTheater.com", pubDate: Date(), title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "865326341", link: "https://www.mysteryBookstore.com", pubDate: Date(), title: "The mystery bookstore")
        
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5]
        
    }
    
    func sampleEpisodeDictForUpdating() -> [[String:Any]] {
        
        let sampleEpisode3 = Episode.serialized(desc: "BART CHEATS ON IQ TEST", fileSize: Double(9134), guid: "12342431", link: "https://www.bartGoesToSchool.com", pubDate: Date(), title: "BART GOES TO SCHOOL")
        
        let sampleEpisode4 = Episode.serialized(desc: "THE GHOSTS IN THE THEATER TURNS OUT TO BE A MADE UP", fileSize: Double(2341), guid: "7652374", link: "https://www.HauntedTheater.com", pubDate: Date(), title: "THE HAUNTED THEATER")
        
        return [sampleEpisode3, sampleEpisode4]
    }
}
