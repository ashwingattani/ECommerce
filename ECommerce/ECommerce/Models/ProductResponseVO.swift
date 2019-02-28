//
//  ProductResponseVO.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

struct ProductResponseVO : Decodable  {
    var productCategoryList:     [ProductCategory]
    var rankings:                [Rankings]
    
    enum ProductResponseVOKeys: String, CodingKey {
        case categories     = "categories"
        case rankings       = "rankings"
    }
    
    init(from decoder: Decoder) throws {
        let container             = try decoder.container(keyedBy: ProductResponseVOKeys.self)
        self.productCategoryList  = try container.decode([ProductCategory].self, forKey: .categories)
        self.rankings             = try container.decode([Rankings].self, forKey: .rankings)
    }
}
