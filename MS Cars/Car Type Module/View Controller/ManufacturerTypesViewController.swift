//
//  ManufacturerTypesViewController.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import UIKit
import SCLAlertView
import DZNEmptyDataSet
import UIScrollView_InfiniteScroll


class ManufacturerTypesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var manufacturer: Manufacturer!
    private var viewModel = ManufacturerTypesViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let manufacturerName = manufacturer.name {
            title = manufacturerName
        }
        
        configureTableView()
        viewModel.delegate = self
        
        refreshControl.addTarget(self, action: #selector(reloadManufacturerTypes), for: UIControl.Event.valueChanged)
        tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadManufacturerTypes()
    }

    func configureTableView() {
        tableView.tableFooterView = UIView()
        
        tableView.addInfiniteScroll { (tableView) -> Void in
            self.viewModel.loadManufacturerTypes(withManufacturerCode: self.manufacturer.code ?? "")
        }
        
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.viewModel.shouldLoadMore
        }
    }
    
    @objc func reloadManufacturerTypes() {
        showLoadingIndicator()
        viewModel.reloadManufacturerTypes(withManufacturerCode: manufacturer.code ?? "")
    }
}


// MARK: ManufacturerTypesViewModel Delegate Methods
extension ManufacturerTypesViewController: ManufacturerTypesViewModelDelegate {
    func manufacturerTypesLoadedSuccessfully() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        hideLoadingIndicator()
        refreshControl.endRefreshing()
        tableView.finishInfiniteScroll()
        tableView.reloadData()
    }
    
    func manufacturerTypesFailedWithError(_ errorMessage: String) {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        hideLoadingIndicator()
        refreshControl.endRefreshing()
        tableView.finishInfiniteScroll()
        SCLAlertView().showError("Error", subTitle: errorMessage)
    }
}


// MARK: UITableView Delegate & DataSource Methods
extension ManufacturerTypesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalManufacturerTypesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.ManufacturerTypeTableViewCell, for: indexPath) as! ManufacturerTypeTableViewCell
        cell.titleLabel.text = viewModel.manufacturerTypeName(at: indexPath.row)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGrayF2F2F2
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let manufacturerName = manufacturer.name {
            SCLAlertView().showInfo("Selected Car", subTitle: "\(manufacturerName), \(viewModel.manufacturerTypeName(at: indexPath.row))")
        }
    }
}


// MARK: DZNEmptyDataSet Delegate & DataSource Methods
extension ManufacturerTypesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No manufacturer types available"
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : UIColor.darkGray484848,
            .font : UIFont(name: "Verdana", size: 16) ?? UIFont.systemFont(ofSize: 16)
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "car-tyre")!
    }
}
