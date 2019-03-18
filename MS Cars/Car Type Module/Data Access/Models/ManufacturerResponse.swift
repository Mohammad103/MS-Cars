//
//  ManufacturerResponse.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/16/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import Foundation

struct ManufacturerResponse {
    
    var manufacturers : [Manufacturer] = []
    let page : Int?
    let pageSize : Int?
    let totalPageCount : Int?
    
    enum CodingKeys: String, CodingKey {
        case wkda = "wkda"
        case page = "page"
        case pageSize = "pageSize"
        case totalPageCount = "totalPageCount"
    }
}


// Decodable
extension ManufacturerResponse: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalPageCount = try values.decodeIfPresent(Int.self, forKey: .totalPageCount)
        
        let manufacturersDic = try values.decodeIfPresent([String: String].self, forKey: .wkda) ?? [:]
        manufacturers = []
        for (code, name) in manufacturersDic {
            let obj = Manufacturer(code: code, name: name)
            manufacturers.append(obj)
        }
    }
}
