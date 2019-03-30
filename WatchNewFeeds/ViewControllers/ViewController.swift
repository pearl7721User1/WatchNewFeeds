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
    let allShowsFetchRequest: NSFetchRequest<Show>
    var coreDataStack: CoreDataStack!
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
    
    @IBAction func feedInstallerButtonTapped(_ sender: UIBarButtonItem) {
        popUpInstallFeedViewController()
    }
    
    @IBAction func syncButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}

