//
//  MyViewController.swift
//  WatchNewFeeds
//
//  Created by GIWON1 on 19/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    var allShowsFetchRequest: NSFetchRequest<Show>
    var coreDataStack: CoreDataStack!
    var context: NSManagedObjectContext!
    
    var shows: [Show]?
    
    var feedInstaller: FeedInstaller
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.allShowsFetchRequest = Show.fetchRequest()
        self.feedInstaller = FeedInstaller() // feed installer?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // feed installer installed or not
        
        // if not installed, show popup
        
        // if installed, proceed
        
    }
    
    private func populateCollectionView() {
        self.shows = coreDataStack.fetchAllShows(context: context)
        
        
    }
    
}
