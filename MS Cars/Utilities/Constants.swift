//
//  Constants.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import Foundation
import UIKit

struct K {
    struct ProductionServer {
        static let baseURL = "http://api-aws-eu-qa-1.auto1-test.com/v1/car-types/"
        static let waValue = "coding-puzzle-client-449cc9d"
    }
    
    struct Identifier {
        static let ManufacturerTableViewCell = "ManufacturerTableViewCell"
        static let ManufacturerTypeTableViewCell = "ManufacturerTypeTableViewCell"
        static let ManufacturerTypeSegue = "ManufacturerTypeSegue"
    }
}
