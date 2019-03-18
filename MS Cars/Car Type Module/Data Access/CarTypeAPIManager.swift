//
//  CarTypeAPIManager.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import Alamofire

class CarTypeAPIManager: NSObject {
    
    class func loadManufacturers(withPage page: Int, pageSize: Int, success: @escaping (_: ManufacturerResponse) -> Void, failure: @escaping (_: String) -> Void) {
        
        Alamofire.request(CarTypeProvider.manufacturers(page: page, pageSize: pageSize)).responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                do {
                    let decoder = JSONDecoder()
                    let manufacturersResponse = try decoder.decode(ManufacturerResponse.self, from: response.data!)
                    print(manufacturersResponse)
                    success(manufacturersResponse)
                    
                } catch let error {
                    let errorMessage = "Parsing failed with error: \(error)"
                    print(errorMessage)
                    failure(errorMessage)
                }
                
            case .failure(let error):
                let errorMessage = "Request failed with error: \(error)"
                print(errorMessage)
                failure(errorMessage)
            }
        }
    }
    
    class func loadManufacturerTypes(withManufacturerCode manufacturerCode: String, page: Int, pageSize: Int, success: @escaping (_: ManufacturerTypeResponse) -> Void, failure: @escaping (_: String) -> Void) {
        
        Alamofire.request(CarTypeProvider.manufacturerTypes(manufacturerCode: manufacturerCode, page: page, pageSize: pageSize)).responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                do {
                    let decoder = JSONDecoder()
                    let typesResponse = try decoder.decode(ManufacturerTypeResponse.self, from: response.data!)
                    print(typesResponse)
                    success(typesResponse)
                    
                } catch let error {
                    let errorMessage = "Parsing failed with error: \(error)"
                    print(errorMessage)
                    failure(errorMessage)
                }
                
            case .failure(let error):
                let errorMessage = "Request failed with error: \(error)"
                print(errorMessage)
                failure(errorMessage)
            }
        }
    }
    
}
