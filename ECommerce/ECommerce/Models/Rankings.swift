//
//  Rankings.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

struct Rankings : Decodable  {
    var ranking:                   String
    var productRankList:           [ProductRank]
    
    enum RankingsKeys: String, CodingKey {
        case ranking                     = "ranking"
        case products                    = "products"
    }
    
    init(from decoder: Decoder) throws {
        let container        = try decoder.container(keyedBy: RankingsKeys.self)
        self.ranking         = try container.decode(String.self, forKey: .ranking)
        self.productRankList = try container.decode([ProductRank].self, forKey: .products)
    }
}
