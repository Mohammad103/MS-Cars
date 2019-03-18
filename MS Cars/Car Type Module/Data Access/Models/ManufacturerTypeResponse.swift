//
//  ManufacturerTypeResponse.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/16/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import Foundation

struct ManufacturerTypeResponse {
    
    var types : [ManufacturerType] = []
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
extension ManufacturerTypeResponse: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalPageCount = try values.decodeIfPresent(Int.self, forKey: .totalPageCount)
        
        let manufacturersDic = try values.decodeIfPresent([String: String].self, forKey: .wkda) ?? [:]
        types = []
        for (_, name) in manufacturersDic {
            let obj = ManufacturerType(name: name)
            types.append(obj)
        }
    }
}
