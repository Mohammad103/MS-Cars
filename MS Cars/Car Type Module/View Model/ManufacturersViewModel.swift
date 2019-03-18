//
//  ManufacturersViewModel.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

protocol ManufacturersViewModelDelegate: class {
    func manufacturersLoadedSuccessfully()
    func manufacturersFailedWithError(_ errorMessage: String)
}


class ManufacturersViewModel {
    
    private let kPageSize = 15
    private var pageNumber = 0
    
    var shouldLoadMore = true
    var manufacturers: [Manufacturer] = []
    weak var delegate: ManufacturersViewModelDelegate?
    
    
    func loadManufacturers() {
        if !self.shouldLoadMore {
            return
        }
        
        CarTypeAPIManager.loadManufacturers(withPage: pageNumber, pageSize: kPageSize, success: { (response) in
            
            self.pageNumber += 1
            if response.page == response.totalPageCount {
                self.shouldLoadMore = false
            }
            self.manufacturers.append(contentsOf: response.manufacturers)
            self.delegate?.manufacturersLoadedSuccessfully()
            
        }, failure: { (errorMessage) in
            self.delegate?.manufacturersFailedWithError(errorMessage)
        })
    }
    
    func reloadManufacturers() {
        self.manufacturers = []
        self.pageNumber = 0
        self.shouldLoadMore = true
        self.loadManufacturers()
    }
    
    func totalManufacturersCount() -> Int {
        return self.manufacturers.count
    }
    
    func manufacturerName(at index: Int) -> String {
        return self.manufacturers[index].name ?? ""
    }
    
    func manufacturer(at index: Int) -> Manufacturer {
        return self.manufacturers[index]
    }
}
