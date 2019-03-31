//
//  InstallFeedCell.swift
//  WatchNewFeeds
//
//  Created by SeoGiwon on 21/03/2019.
//  Copyright © 2019 SeoGiwon. All rights reserved.
//

import UIKit

class InstallFeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var buttonAction: (()->Void)?
    
    static func identifier() -> String {
        return "InstallFeedCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String, buttonAction: (()->Void)?) {
        
        self.titleLabel.text = title
        
        if buttonAction != nil {
            self.button.isEnabled = true
            self.button.setTitle("Install", for: .normal)
            
        } else {
            self.button.isEnabled = false
            self.button.setTitle("Installed", for: .normal)
        }
        
        self.buttonAction = buttonAction
        self.button.addTarget(self, action: #selector(buttonActionSelector), for: .touchUpInside)
    }
    
    private func temporarilyDisableButton() {
        self.button.isEnabled = false
        self.button.setTitle("Installing", for: .normal)
    }
    
    @objc func buttonActionSelector(_ sender: UIButton) {
        if let buttonAction = self.buttonAction {
            temporarilyDisableButton()
            buttonAction()
        }
    }
    
}
