//
//  ManufacturersViewController.swift
//  MS Cars
//
//  Created by Mohammad Shaker on 3/18/19.
//  Copyright © 2019 Mohammad Shaker. All rights reserved.
//

import UIKit
import SCLAlertView
import DZNEmptyDataSet
import UIScrollView_InfiniteScroll


class ManufacturersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    private var viewModel = ManufacturersViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        viewModel.delegate = self
        
        refreshControl.addTarget(self, action: #selector(reloadManufacturers), for: UIControl.Event.valueChanged)
        tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadManufacturers()
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        
        tableView.addInfiniteScroll { (tableView) -> Void in
            self.viewModel.loadManufacturers()
        }
        
        tableView.setShouldShowInfiniteScrollHandler { _ -> Bool in
            return self.viewModel.shouldLoadMore
        }
    }
    
    @objc func reloadManufacturers() {
        showLoadingIndicator()
        viewModel.reloadManufacturers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.ManufacturerTypeSegue {
            let vc = segue.destination as! ManufacturerTypesViewController
            if let index = tableView.indexPathForSelectedRow?.row {
                vc.manufacturer = viewModel.manufacturer(at: index)
            }
        }
    }
}


// MARK: ManufacturersViewModel Delegate Methods
extension ManufacturersViewController: ManufacturersViewModelDelegate {
    func manufacturersLoadedSuccessfully() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        hideLoadingIndicator()
        refreshControl.endRefreshing()
        tableView.finishInfiniteScroll()
        tableView.reloadData()
    }
    
    func manufacturersFailedWithError(_ errorMessage: String) {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        hideLoadingIndicator()
        refreshControl.endRefreshing()
        tableView.finishInfiniteScroll()
        SCLAlertView().showError("Error", subTitle: errorMessage)
    }
}


// MARK: UITableView Delegate & DataSource Methods
extension ManufacturersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalManufacturersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.ManufacturerTableViewCell, for: indexPath) as! ManufacturerTableViewCell
        cell.titleLabel.text = viewModel.manufacturerName(at: indexPath.row)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGrayF2F2F2
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: DZNEmptyDataSet Delegate & DataSource Methods
extension ManufacturersViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No manufacturers available"
        
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
