//
//  ViewController.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var allShowsFetchRequest: NSFetchRequest<Show>
    var coreDataStack: CoreDataStack!
    var context: NSManagedObjectContext!
    var feedInstaller: FeedInstaller!
    
    var shows: [Show]?
    
    
    required init?(coder aDecoder: NSCoder) {
        self.allShowsFetchRequest = Show.fetchRequest()
        super.init(coder: aDecoder)        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func populateCollectionView() {
        
        self.shows = coreDataStack.fetchAllShows(context: context)
        collectionView.reloadData()
    }
    
    private func popUpInstallFeedViewController() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstallBaseFeedViewController") as! InstallBaseFeedViewController
        self.present(vc, animated: true, completion: nil)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
    
}

