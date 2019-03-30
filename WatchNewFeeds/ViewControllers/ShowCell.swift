//
//  ShowCell.swift
//  WatchNewFeeds
//
//  Created by GIWON1 on 20/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class ShowCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var episodesTotalLabel: UILabel!
    
    static func identifier() -> String {
        return "ShowCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(image: UIImage?, showTitle: String, availableEpisodes: Int) {
        self.imageView.image = image
        self.showTitleLabel.text = showTitle
        self.episodesTotalLabel.text = "\(availableEpisodes) episodes"
    }
}
