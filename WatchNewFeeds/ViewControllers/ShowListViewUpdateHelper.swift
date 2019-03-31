//
//  ShowListViewUpdateHelper.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 31/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

struct ShowListViewUpdateInfo {
    let insertRequired: [IndexPath]?
    let updateRequired: [IndexPath]?
    let deleteRequired: [IndexPath]?
    let newShows: [Show]
}

class ShowListViewUpdateHelper: NSObject {

    func showListViewUpdateInfo(notification: Notification, shows: [Show]) -> ShowListViewUpdateInfo? {
        
        guard let userInfo = notification.userInfo else {
            return nil
        }
        
        var newShows = shows
        
        if let insertedSet = userInfo[NSInsertedObjectsKey] as? Set<Show> {

            let insertNeeded = Array(insertedSet).filter{$0.objectID.isTemporaryID == false}
            
            let section = 0
            let newShowsCountBeforeInsert = newShows.count
            newShows.append(contentsOf: insertNeeded)
            let newShowsCountAfterInsert = newShows.count
            
            var insertedIndexPaths = [IndexPath]()
            for i in stride(from: newShowsCountBeforeInsert, to: newShowsCountAfterInsert, by: 1) {
                insertedIndexPaths.append(IndexPath(item: i, section: section))
            }
            
            return ShowListViewUpdateInfo(insertRequired: insertedIndexPaths, updateRequired:nil, deleteRequired: nil, newShows: newShows)
        } else if let updatedSet = userInfo[NSUpdatedObjectsKey] as? Set<Show> {
            
            let mightBeUpdated = Array(updatedSet).filter{$0.objectID.isTemporaryID == false}
            var updateNeededIndexPaths = [IndexPath]()
            let section = 0
            
            for (_,v) in mightBeUpdated.enumerated() {
                
                var indexOfInterest = -1
                for (j,u) in shows.enumerated() {
                    if v.objectID == u.objectID {
                        indexOfInterest = j
                    }
                }
                
                if (indexOfInterest != -1) {
                    newShows.remove(at: indexOfInterest)
                    newShows.insert(v, at: indexOfInterest)
                    updateNeededIndexPaths.append(IndexPath(item: indexOfInterest, section: section))
                }
            }
            
            return ShowListViewUpdateInfo(insertRequired: nil, updateRequired:updateNeededIndexPaths, deleteRequired: nil, newShows: newShows)
            
        } else if let deletedSet = userInfo[NSDeletedObjectsKey] as? Set<Show> {
            
            let mightBeDeleted = Array(deletedSet).filter{$0.objectID.isTemporaryID == false}
            var deletedNeededIndexes = [Int]()
            
            for (i,v) in shows.enumerated() {
                
                if (mightBeDeleted.map{$0.objectID}).contains(v.objectID) {
                    deletedNeededIndexes.append(i)
                }
            }
            
            let deletedShows = shows.enumerated()
                .filter { !deletedNeededIndexes.contains($0.offset) }
                .map { $0.element }
            
            newShows = deletedShows
            
            let section = 0
            let deletedIndexPaths = deletedNeededIndexes.map{IndexPath(item:$0, section:section)}
            
            return ShowListViewUpdateInfo(insertRequired: nil, updateRequired:nil, deleteRequired: deletedIndexPaths, newShows: newShows)
        }
        
        return nil
    }
    
}
