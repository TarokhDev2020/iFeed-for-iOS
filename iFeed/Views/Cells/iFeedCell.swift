//
//  iFeedCell.swift
//  iFeed
//
//  Created by Tarokh on 8/19/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import UIKit
import CoreData

class iFeedCell: UITableViewCell {

    //MARK: - @IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
