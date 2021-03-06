//
//  EpisodeComparator.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 20/02/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit


class EpisodeComparator {
    
    func compare(episodes: [Episode], episodeTuples: [EpisodeFeedTuple]) -> EpisodeComparatorResult {
        
        var episodeCompareResult = EpisodeComparatorResult()
        
        episodeCompareResult.deleteRequired = deleteRequired(episodes: episodes, episodeTuples: episodeTuples)
        
        episodeCompareResult.updateRequired = updateRequired(episodes: episodes, episodeTuples: episodeTuples)
        
        episodeCompareResult.insertRequired = insertRequired(episodes: episodes, episodeTuples: episodeTuples)
        
        return episodeCompareResult
    }
    
    private func deleteRequired(episodes: [Episode], episodeTuples: [EpisodeFeedTuple]) -> [String] {
        
        var deleteRequiredGuids = [String]()
        
        for (_,v) in episodes.enumerated() {
            
            if (episodeTuples.filter{$0.guid == (v.guid ?? "")}).first == nil {
                deleteRequiredGuids.append(v.guid ?? "")
            }
            
        }
        
        return deleteRequiredGuids
    }
    
    private func updateRequired(episodes: [Episode], episodeTuples: [EpisodeFeedTuple]) -> [EpisodeFeedTuple] {
        
        var updateRequired = [EpisodeFeedTuple]()
        
        for (_,v) in episodes.enumerated() {
            
            if let guidMatched = (episodeTuples.filter{$0.guid == v.guid ?? ""}).first {
                
                if guidMatched.pubDate > (v.pubDate as Date?) ?? Date() {
                    updateRequired.append(guidMatched)
                }
            }
            
        }
        
        return updateRequired
    }
    
    private func insertRequired(episodes: [Episode], episodeTuples: [EpisodeFeedTuple]) -> [EpisodeFeedTuple] {
        
        var insertRequired = [EpisodeFeedTuple]()
        
        for (_,v) in episodeTuples.enumerated() {
            
            if (episodes.filter{$0.guid ?? "" == v.guid}).first == nil {
                insertRequired.append(v)
            }
        }
        
        return insertRequired
    }
}



struct EpisodeComparatorResult {
    var deleteRequired = [String]()
    var updateRequired = [EpisodeFeedTuple]()
    var insertRequired = [EpisodeFeedTuple]()
}
