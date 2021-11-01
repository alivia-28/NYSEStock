//
//  StocksTableViewController.swift
//  NYSEStock
//
//  Created by Alivia Guin on 10/29/21.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class StocksTableViewController: UITableViewController, UISearchBarDelegate {
        
    var arrCompanyInfo : [CompanyInfo] = [CompanyInfo]()
    var arrSearch : [CompanyInfo] = [CompanyInfo]()
    var companyDetail : CompanyInfo?
    
    let stockQuoteURL = "https://financialmodelingprep.com/api/v3/quote-short/"
    let companyProfileURL = "https://financialmodelingprep.com/api/v3/profile/"
    let apiKey = "7944c7ed8bb2eea5c7913e92669fd37d"

    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        loadStockValues()
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func addStockAction(_ sender: Any) {
        var globalTextField: UITextField?
        let actionController = UIAlertController(title: "Add Stock Symbol", message: "", preferredStyle: .alert)
        let OKButton = UIAlertAction(title: "OK", style: .default) { action in
            guard let symbol = globalTextField?.text else {return}
            
            if symbol == "" {
                return
            }
            self.storeValuesInDB(symbol.uppercased())
        }
        let CancelButton = UIAlertAction(title: "Cancel", style: .default) { action in
            print("I am cancel")
        }
        actionController.addAction(OKButton)
        actionController.addAction(CancelButton)
        
        actionController.addTextField { stockTextField in
            stockTextField.placeholder = "Stock Symbol"
            globalTextField = stockTextField
            
        }
        
        self.present(actionController, animated: true, completion: nil)

    }
    
    //first func that is being called
    func loadStockValues() {
        do {
            let realm = try Realm()
            let companies = realm.objects(CompanyInfo.self)
            
            arrCompanyInfo.removeAll()
            
            getAllCompanyInfo(Array(companies)).done { companiesInfo in
                self.arrCompanyInfo.append(contentsOf: companiesInfo)
                self.arrSearch.append(contentsOf: companiesInfo)
                self.tblView.reloadData()
            }
            .catch { error in
                print(error)
            }
            
            tblView.reloadData()
        } catch {
            print("Error in reading Database \(error)")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchBar.text!.isEmpty else {
            arrCompanyInfo = arrSearch
            tblView.reloadData()
            return
        }
        
        arrCompanyInfo = arrSearch.filter({ company in
            company.symbol.lowercased().contains(searchBar.text!.lowercased())
        })
        tblView.reloadData()
    }
    
    
    
}
