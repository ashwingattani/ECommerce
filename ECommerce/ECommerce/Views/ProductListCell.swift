//
//  ProductListCell.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        
    }
    
}
