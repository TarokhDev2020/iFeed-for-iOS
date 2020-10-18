//
//  FeedCell.swift
//  iFeed
//
//  Created by Tarokh on 8/20/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    
    //MARK: - @IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(with feedModel: FeedModel) {
        self.titleLabel.text = feedModel.title
        self.dateLabel.text = feedModel.date
    }

}
