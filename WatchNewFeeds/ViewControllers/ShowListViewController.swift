//
//  ViewController.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class ShowListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let allShowsFetchRequest: NSFetchRequest<Show>
    var coreDataStack: CoreDataStack!
    var syncManager: SyncManager!
    lazy var context: NSManagedObjectContext = {
       return coreDataStack.persistentContainer.viewContext
    }()
    
    var shows: [Show]!
    
    required init?(coder aDecoder: NSCoder) {
        allShowsFetchRequest = Show.fetchRequest()
        super.init(coder: aDecoder)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shows = coreDataStack.fetchAllShows(context: context)
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            // do nothing
        }
    }
    
    @objc func contextObjectsDidChange(notification:Notification) {
        
        print("contextObjectsDidChange called")
        
        let listUpdateHelper = ShowListViewUpdateHelper()
        if let viewUpdateInfo = listUpdateHelper.showListViewUpdateInfo(notification: notification, shows: self.shows) {
            
            self.shows = viewUpdateInfo.newShows
            
            
            
            DispatchQueue.main.async {
                if let insertRequired = viewUpdateInfo.insertRequired {
                    
                    print("insertRequired shows:\(insertRequired.count)")
                    
                    self.collectionView.insertItems(at: insertRequired)
                }
                if let updateRequired = viewUpdateInfo.updateRequired {
                    
                    print("upateRequired shows:\(updateRequired.count)")
                    self.collectionView.reloadItems(at: updateRequired)
                }
                if let deleteRequired = viewUpdateInfo.deleteRequired {
                    
                    print("deleteRequired shows:\(deleteRequired.count)")
                    self.collectionView.deleteItems(at: deleteRequired)
                }
            }
            
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    private func popUpInstallFeedViewController() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstallBaseFeedNavigationController") as! InstallBaseFeedNavigationController
        vc.coreDataStack = coreDataStack
        self.present(vc, animated: true, completion: nil)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let showCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCell.identifier(), for: indexPath) as! ShowCell
        
        let show = shows[indexPath.row]
        
        var image: UIImage? {
            if let imageData = show.logoImage,
                let image = UIImage(data: imageData as Data) {
                return image
            } else {
                return nil
            }
        }
        
        showCell.configure(image: image, showTitle: show.title ?? "", availableEpisodes: show.episodes?.count ?? 0)
            
        return showCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let episodeSet = self.shows[indexPath.item].episodes as? Set<Episode> {
            
            let episodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EpisodeTableViewController") as! EpisodeTableViewController
            
            episodeVC.episodes = Array(episodeSet).sorted { (lv, rv) -> Bool in
                
                let pubDateLv = (lv.pubDate as Date?) ?? Date()
                let pubDateRv = (rv.pubDate as Date?) ?? Date()
                
                if pubDateLv.compare(pubDateRv) == .orderedAscending {
                    return false
                } else {
                    return true
                }
            }
            self.navigationController?.pushViewController(episodeVC, animated: true)
        }
        
        
    }
    
    @IBAction func feedInstallerButtonTapped(_ sender: UIBarButtonItem) {
        popUpInstallFeedViewController()
    }
    
    @IBAction func syncButtonTapped(_ sender: UIBarButtonItem) {
        self.syncManager.sync(completion: nil)
    }
}

