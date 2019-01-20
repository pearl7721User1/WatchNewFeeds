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
        sut.addEpisodes(dictArray: episodesForAdding, context: backgroundContext)
        
        
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
        sut.addEpisodes(dictArray: episodesForAdding, context: backgroundContext)
        
        let episodesForUpdating = sampleEpisodeDictForUpdating()
        sut.updateEpisodes(dictArray: episodesForUpdating, context: backgroundContext)
        
        
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
        /*
        @NSManaged public var title: String?
        @NSManaged public var desc: String?
        @NSManaged public var link: String?
        @NSManaged public var guid: String?
        @NSManaged public var pubDate: NSDate?
        @NSManaged public var fileSize: Int16
        @NSManaged public var show: Show?
        */
        
        let sampleEpisode1: [String: Any] = ["title": "Roasting Fire",
                    "desc": "The Simpsons goes to see the quack",
                    "link": "https://www.roastingFire.com",
                    "guid": "7987239841",
                    "pubDate": "pubDate",
                    "fileSize": Int64(12356)]
        
        let sampleEpisode2: [String: Any] = ["title": "Lisa got braces",
                              "desc": "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare",
                              "link": "https://www.lisaGotBraces.com",
                              "guid": "2341928",
                              "pubDate": "pubDate",
                              "fileSize": Int64(123455)]
        
        let sampleEpisode3: [String: Any] = ["title": "Bart goes to school",
                              "desc": "Bart cheats on the iq tests and goes to a genius school",
                              "link": "https://www.bartGoesToSchool.com",
                              "guid": "12342431",
                              "pubDate": "pubDate",
                              "fileSize": Int64(9134)]
        
        let sampleEpisode4: [String: Any] = ["title": "The haunted theater",
                              "desc": "The Alden children solves the mystery of the huanted theater in Elmford",
                              "link": "https://www.HauntedTheater.com",
                              "guid": "7652374",
                              "pubDate": "pubDate",
                              "fileSize": Int64(2341)]
        
        let sampleEpisode5: [String: Any] = ["title": "The mystery bookstore",
                              "desc": "The Alden children help run the mystery bookstore",
                              "link": "https://www.mysteryBookstore.com",
                              "guid": "865326341",
                              "pubDate": "pubDate",
                              "fileSize": Int64(2863)]
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5]
        
    }
    
    func sampleEpisodeDictForUpdating() -> [[String:Any]] {
        let sampleEpisode3: [String: Any] = ["title": "BART GOES TO SCHOOL",
                                             "desc": "BART CHEATS ON IQ TEST",
                                             "link": "https://www.bartGoesToSchool.com",
                                             "guid": "12342431",
                                             "pubDate": "pubDate",
                                             "fileSize": Int64(9134)]
        
        let sampleEpisode4: [String: Any] = ["title": "THE HAUNTED THEATER",
                                             "desc": "THE GHOSTS IN THE THEATER TURNS OUT TO BE A MADE UP",
                                             "link": "https://www.HauntedTheater.com",
                                             "guid": "7652374",
                                             "pubDate": "pubDate",
                                             "fileSize": Int64(2341)]
        return [sampleEpisode3, sampleEpisode4]
    }
}
