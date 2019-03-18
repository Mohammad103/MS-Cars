//
//  ManufacturerTypesViewModel.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

protocol ManufacturerTypesViewModelDelegate: class {
    func manufacturerTypesLoadedSuccessfully()
    func manufacturerTypesFailedWithError(_ errorMessage: String)
}


class ManufacturerTypesViewModel {
    
    private let kPageSize = 15
    private var pageNumber = 0
    
    var shouldLoadMore = true
    var manufacturerTypes: [ManufacturerType] = []
    weak var delegate: ManufacturerTypesViewModelDelegate?
    
    
    func loadManufacturerTypes(withManufacturerCode manufacturerCode: String) {
        if !self.shouldLoadMore {
            return
        }
        
        CarTypeAPIManager.loadManufacturerTypes(withManufacturerCode: manufacturerCode, page: pageNumber, pageSize: kPageSize, success: { (response) in
            
            self.pageNumber += 1
            if response.page == response.totalPageCount {
                self.shouldLoadMore = false
            }
            self.manufacturerTypes.append(contentsOf: response.types)
            self.delegate?.manufacturerTypesLoadedSuccessfully()
            
        }, failure: { (errorMessage) in
            self.delegate?.manufacturerTypesFailedWithError(errorMessage)
        })
    }
    
    func reloadManufacturerTypes(withManufacturerCode manufacturerCode: String) {
        self.manufacturerTypes = []
        self.pageNumber = 0
        self.shouldLoadMore = true
        self.loadManufacturerTypes(withManufacturerCode: manufacturerCode)
    }
    
    func totalManufacturerTypesCount() -> Int {
        return self.manufacturerTypes.count
    }
    
    func manufacturerTypeName(at index: Int) -> String {
        return self.manufacturerTypes[index].name ?? ""
    }
    
    func manufacturerType(at index: Int) -> ManufacturerType {
        return self.manufacturerTypes[index]
    }
}
