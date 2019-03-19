//
//  ViewController.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData

let BaseFeedURL: URL = URL(string:"http:allearsenglish.libsyn.com/rss")!

class ViewController: UIViewController {

    var allShowsFetchRequest: NSFetchRequest<Show>
    var coreDataStack: CoreDataStack!
    var context: NSManagedObjectContext!
    var feedInstaller: FeedInstaller!
    
    var shows: [Show]?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.allShowsFetchRequest = Show.fetchRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedInstaller = FeedInstaller(feedUrl: BaseFeedURL, coreDataStack: self.coreDataStack)
        
        // feed installer installed or not
        if self.feedInstaller.doAnyFeedsExist() {
            populateCollectionView()
        } else {
            popUpInstallFeedViewController()
        }
    }
    
    private func populateCollectionView() {
        
        self.shows = coreDataStack.fetchAllShows(context: context)
        
        
        
    }
    
    private func popUpInstallFeedViewController() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstallBaseFeedViewController") as! InstallBaseFeedViewController
        vc.feedInstaller = self.feedInstaller
        self.present(vc, animated: true, completion: nil)
        
    }

}

