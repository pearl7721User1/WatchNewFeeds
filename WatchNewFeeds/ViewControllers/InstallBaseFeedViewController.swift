//
//  InstallBaseFeedViewController.swift
//  WatchNewFeeds
//
//  Created by GIWON1 on 19/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class InstallBaseFeedViewController: UIViewController, UITableViewDataSource {
    
    var coreDataStack: CoreDataStack!
    private lazy var feedInstaller: FeedInstaller = {
        let feedUrls = FeedInstaller.sampleFeedUrls()
        return FeedInstaller(feedUrls: feedUrls, coreDataStack: coreDataStack)
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    private var existingFeeds: [URL] {
        return self.feedInstaller.existingFeeds()
    }
    
    private var installedFeeds: [URL] {
        return self.feedInstaller.installedFeeds()
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstallFeedCell.identifier(), for: indexPath) as! InstallFeedCell
        
        let rssFeedUrl = existingFeeds[indexPath.row]
        
        let title = rssFeedUrl.absoluteString
        let isInstalled = installedFeeds.contains(rssFeedUrl)
        
        var buttonAction: (() -> Void)?
        if isInstalled == false {
            
            buttonAction = {
                print("isgoingToInstall")
                
                self.feedInstaller.installFeed(url: rssFeedUrl) { (finished) in
                    print("installed")
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    
                }
            }
            
        }
        
        cell.configure(title: title, buttonAction: buttonAction)

        return cell
    }
}
