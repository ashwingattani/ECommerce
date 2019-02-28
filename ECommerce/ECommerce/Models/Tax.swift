//
//  Tax.swift
//  ECommerce
//
//  Created by Ashwin Gattani on 01/03/19.
//  Copyright © 2019 Example. All rights reserved.
//

import Foundation

struct Tax : Decodable  {
    var name:             String
    var value:            Float
    
    enum TaxKeys: String, CodingKey {
        case name         = "name"
        case value        = "value"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TaxKeys.self)
        self.name     = try container.decode(String.self,   forKey: .name)
        self.value    = try container.decode(Float.self, forKey: .value)
    }
}
