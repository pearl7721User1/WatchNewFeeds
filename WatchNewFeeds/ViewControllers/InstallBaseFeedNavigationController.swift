//
//  InstallBaseFeedNavigationController.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 21/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class InstallBaseFeedNavigationController: UINavigationController {

    var coreDataStack: CoreDataStack! {
        didSet {
            (self.viewControllers[0] as! InstallBaseFeedViewController).coreDataStack = coreDataStack
        }
    }
    
    
}
