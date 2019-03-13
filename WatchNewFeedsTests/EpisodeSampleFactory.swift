//
//  EpisodeSampleFactory.swift
//  WatchNewFeedsTests
//
//  Created by SeoGiwon on 12/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

@testable import WatchNewFeeds

class EpisodeSampleFactory: NSObject {

    static func sampleFeedEpisodes() -> [[String:Any]] {
        
        let sampleEpisode1 = Episode.serialized(desc: "The Simpsons goes to see the quack", fileSize: Double(12356), guid: "1", link: "https://www.roastingFire.com", pubDate: Date(), title: "Roasting Fire")
        
        let sampleEpisode2 = Episode.serialized(desc: "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare", fileSize: Double(123455), guid: "2", link: "https://www.lisaGotBraces.com", pubDate: Date(), title: "Lisa got braces")
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "3", link: "https://www.bartGoesToSchool.com", pubDate: Date(), title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "4", link: "https://www.HauntedTheater.com", pubDate: Date(), title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "5", link: "https://www.mysteryBookstore.com", pubDate: Date(), title: "The mystery bookstore")
        
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5]
        
    }
    
    static func sampleFeedEpisodes2() -> [[String:Any]] {
        
        let sampleEpisode3 = Episode.serialized(desc: "BART CHEATS ON IQ TEST", fileSize: Double(9134), guid: "3", link: "https://www.bartGoesToSchool.com", pubDate: Date(), title: "BART GOES TO SCHOOL")
        
        let sampleEpisode4 = Episode.serialized(desc: "THE GHOSTS IN THE THEATER TURNS OUT TO BE A MADE UP", fileSize: Double(2341), guid: "4", link: "https://www.HauntedTheater.com", pubDate: Date(), title: "THE HAUNTED THEATER")
        
        return [sampleEpisode3, sampleEpisode4]
    }
    
    
    static func sampleFeedEpisodesForJan2018() -> [[String:Any]] {
        
        let date = Date(timeIntervalSince1970: 3000)
        
        let sampleEpisode1 = Episode.serialized(desc: "The Simpsons goes to see the quack", fileSize: Double(12356), guid: "10", link: "https://www.roastingFire.com", pubDate: date, title: "Roasting Fire")
        
        let sampleEpisode2 = Episode.serialized(desc: "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare", fileSize: Double(123455), guid: "11", link: "https://www.lisaGotBraces.com", pubDate: date, title: "Lisa got braces")
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "12", link: "https://www.bartGoesToSchool.com", pubDate: date, title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "13", link: "https://www.HauntedTheater.com", pubDate: date, title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "14", link: "https://www.mysteryBookstore.com", pubDate: date, title: "The mystery bookstore")
        
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5]
    }
    
    /// all pubDates updated
    static func sampleFeedEpisodesForFeb2018() -> [[String:Any]] {
        
        let date = Date(timeIntervalSince1970: 4000)
        
        let sampleEpisode1 = Episode.serialized(desc: "The Simpsons goes to see the quack", fileSize: Double(12356), guid: "10", link: "https://www.roastingFire.com", pubDate: date, title: "Roasting Fire")
        
        let sampleEpisode2 = Episode.serialized(desc: "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare", fileSize: Double(123455), guid: "11", link: "https://www.lisaGotBraces.com", pubDate: date, title: "Lisa got braces")
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "12", link: "https://www.bartGoesToSchool.com", pubDate: date, title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "13", link: "https://www.HauntedTheater.com", pubDate: date, title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "14", link: "https://www.mysteryBookstore.com", pubDate: date, title: "The mystery bookstore")
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5]
    }
    
    /// some new episodes added
    static func sampleFeedEpisodesForMar2018() -> [[String:Any]] {
        
        let date = Date(timeIntervalSince1970: 3000)
        
        let sampleEpisode1 = Episode.serialized(desc: "The Simpsons goes to see the quack", fileSize: Double(12356), guid: "10", link: "https://www.roastingFire.com", pubDate: date, title: "Roasting Fire")
        
        let sampleEpisode2 = Episode.serialized(desc: "Homer organizes the union to fight the newclear power plant's sweeping cut on healthcare", fileSize: Double(123455), guid: "11", link: "https://www.lisaGotBraces.com", pubDate: date, title: "Lisa got braces")
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "12", link: "https://www.bartGoesToSchool.com", pubDate: date, title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "13", link: "https://www.HauntedTheater.com", pubDate: date, title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "14", link: "https://www.mysteryBookstore.com", pubDate: date, title: "The mystery bookstore")
        
        let sampleEpisode6 = Episode.serialized(desc: "Former detective John has fear of height", fileSize: Double(12356), guid: "15", link: "https://www.vertigo.com", pubDate: date, title: "Vertigo")
        
        let sampleEpisode7 = Episode.serialized(desc: "Putting up posters is a hard work", fileSize: Double(123455), guid: "16", link: "https://www.puttingUpPosters.com", pubDate: date, title: "Trapdoor theater part time work")
        
        return [sampleEpisode1, sampleEpisode2, sampleEpisode3, sampleEpisode4, sampleEpisode5, sampleEpisode6, sampleEpisode7]
    }
    
    /// some existing episodes deleted
    static func sampleFeedEpisodesForApr2018() -> [[String:Any]] {
        
        let date = Date(timeIntervalSince1970: 3000)
        
        let sampleEpisode3 = Episode.serialized(desc: "Bart cheats on the iq tests and goes to a genius school", fileSize: Double(9134), guid: "12", link: "https://www.bartGoesToSchool.com", pubDate: date, title: "Bart goes to school")
        
        let sampleEpisode4 = Episode.serialized(desc: "The Alden children solves the mystery of the huanted theater in Elmford", fileSize: Double(2341), guid: "13", link: "https://www.HauntedTheater.com", pubDate: date, title: "The haunted theater")
        
        let sampleEpisode5 = Episode.serialized(desc: "The Alden children help run the mystery bookstore", fileSize: Double(2863), guid: "14", link: "https://www.mysteryBookstore.com", pubDate: date, title: "The mystery bookstore")
        
        let sampleEpisode6 = Episode.serialized(desc: "Former detective John has fear of height", fileSize: Double(12356), guid: "15", link: "https://www.vertigo.com", pubDate: date, title: "Vertigo")
        
        let sampleEpisode7 = Episode.serialized(desc: "Putting up posters is a hard work", fileSize: Double(123455), guid: "16", link: "https://www.puttingUpPosters.com", pubDate: date, title: "Trapdoor theater part time work")
        
        return [sampleEpisode3, sampleEpisode4, sampleEpisode5, sampleEpisode6, sampleEpisode7]
    }
    
}
