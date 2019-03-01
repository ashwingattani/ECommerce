//
//  ProductDetailCell.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class ProductDetailCell: UICollectionViewCell {

    @IBOutlet weak var colorLabel:        UILabel!
    @IBOutlet weak var sizeLabel:         UILabel!
    @IBOutlet weak var priceLabel:        UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
