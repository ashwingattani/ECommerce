//
//  Variant.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

struct Variant : Decodable  {
    var id:               Int
    var color:            String
    var size:             Int?
    var price:            Int
    
    enum VariantKeys: String, CodingKey {
        case id           = "id"
        case color        = "color"
        case size         = "size"
        case price        = "price"
    }
    
    init(from decoder: Decoder) throws {
        let container    = try decoder.container(keyedBy: VariantKeys.self)
        self.id          = try container.decode(Int.self, forKey: .id)
        self.color       = try container.decode(String.self, forKey: .color)
        self.size        = try container.decodeIfPresent(Int.self, forKey: .size)
        self.price       = try container.decode(Int.self, forKey: .price)
    }
}
