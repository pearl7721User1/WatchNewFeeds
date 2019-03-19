//
//  InstallBaseFeedViewController.swift
//  WatchNewFeeds
//
//  Created by GIWON1 on 19/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class InstallBaseFeedViewController: UIViewController {

    var feedInstaller: FeedInstaller!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func installButtonTapped(_ sender: UIButton) {
        
        // network indicator on
        feedInstaller.installFeed(completion: {finished in
            
            // network indicator off
            if finished {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
