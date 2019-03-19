//
//  ViewController.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 19/01/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

let BaseFeedURL: URL = URL(string:"http:allearsenglish.libsyn.com/rss")!

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let operation = FeedPullOperation(feedUrl: URL(string:"http:allearsenglish.libsyn.com/rss")!)
        operation.start()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

