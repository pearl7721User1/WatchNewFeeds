//
//  EpisodeComparator.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit


class EpisodeComparator {
    
    func compare(episodes: [Episode], episodesDict: [[String: Any]]) -> EpisodeComparatorResult {
        
        var episodeCompareResult = EpisodeComparatorResult()
        
        episodeCompareResult.deleteRequired = deleteRequired(episodes: episodes, episodesDict: episodesDict)
        
        episodeCompareResult.updateRequired = updateRequired(episodes: episodes, episodesDict: episodesDict)
        
        episodeCompareResult.insertRequired = insertRequired(episodes: episodes, episodesDict: episodesDict)
        
        return episodeCompareResult
    }
    
    private func deleteRequired(episodes: [Episode], episodesDict: [[String:Any]]) -> [String]? {
        
        return nil
    }
    
    private func updateRequired(episodes: [Episode], episodesDict: [[String:Any]]) -> [[String:Any]]? {
        
        return nil
    }
    
    private func insertRequired(episodes: [Episode], episodesDict: [[String:Any]]) -> [[String:Any]]? {
        
        return nil
    }
}



struct EpisodeComparatorResult {
    var deleteRequired: [String]?
    var updateRequired: [[String:Any]]?
    var insertRequired: [[String:Any]]?
}
