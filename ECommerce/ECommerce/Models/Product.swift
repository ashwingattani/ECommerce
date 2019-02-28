//
//  Product.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

struct Product : Decodable  {
    var id:                     Int
    var name:                   String
    var date_added:             String
    var variantList:            [Variant]
    var tax:                    Tax
    
    enum ProductKeys: String, CodingKey {
        case id                = "id"
        case name              = "name"
        case dateAdded         = "date_added"
        case variants          = "variants"
        case tax               = "tax"
    }
    
    init(from decoder: Decoder) throws {
        let container    = try decoder.container(keyedBy: ProductKeys.self)
        self.id          = try container.decode(Int.self, forKey: .id)
        self.name        = try container.decode(String.self, forKey: .name)
        self.date_added  = try container.decode(String.self, forKey: .dateAdded)
        self.variantList = try container.decode([Variant].self, forKey: .variants)
        self.tax         = try container.decode(Tax.self, forKey: .tax)
        DatabaseManager.sharedInstance.saveProductDataInDatabase(model: self)
    }
}
