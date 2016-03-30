//
//  ProjectsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Elise LIVET on 3/25/16.
//  Copyright © 2016 Elise LIVET. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
