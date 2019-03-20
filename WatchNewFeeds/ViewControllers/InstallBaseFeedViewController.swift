//
//  InstallBaseFeedViewController.swift
//  WatchNewFeeds
//
//  Created by GIWON1 on 19/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class InstallBaseFeedViewController: UIViewController {

    private var feedInstaller: FeedInstaller!
    var coreDataStack: CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let feedUrls = FeedInstaller.sampleFeedUrls()
        self.feedInstaller = FeedInstaller(feedUrls: feedUrls, coreDataStack: coreDataStack)
    }
    

}
