//
//  EpisodeCell.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 31/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    
    static func identifier() -> String {
        return "EpisodeCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(episode: Episode) {
        titleLabel.text = episode.title
        descLabel.text = episode.desc
        if let pubDate = episode.pubDate {
            pubDateLabel.text = (pubDate as Date).string(capitalized: true, withinAWeekFormat: "EEEE", otherDatesFormat: "d MMM yyyy")
        }
        
        
    }
}
