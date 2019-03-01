//
//  ProductRankListCell.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class ProductRankListCell: UITableViewCell {
    @IBOutlet weak var imageViewProduct:    UIImageView!
    @IBOutlet weak var nameLabel:           UILabel!
    @IBOutlet weak var countLabel:          UILabel!

    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
