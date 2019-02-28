//
//  ProductCategory.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

struct ProductCategory : Decodable  {
    var id:                     Int
    var name:                   String
    var productList:            [Product]
    var child_categories:       [Int]
    
    enum ProductCategoryKeys: String, CodingKey {
        case id                     = "id"
        case name                   = "name"
        case products               = "products"
        case childCategories        = "child_categories"
    }
    
    init(from decoder: Decoder) throws {
        let container         = try decoder.container(keyedBy: ProductCategoryKeys.self)
        self.id               = try container.decode(Int.self, forKey: .id)
        self.name             = try container.decode(String.self, forKey: .name)
        self.productList      = try container.decode([Product].self, forKey: .products)
        self.child_categories = try container.decode([Int].self, forKey: .childCategories)
    }
}
