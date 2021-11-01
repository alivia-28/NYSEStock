//
//  StockTableViewCode.swift
//  NYSEStock
//
//  Created by Alivia Guin on 10/29/21.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

extension StocksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrCompanyInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cell = Bundle.main.loadNibNamed("StockTableViewCell", owner: self, options: nil)?.first as! StockTableViewCell
        cell.lblSymbol.text = arrCompanyInfo[indexPath.row].symbol
        cell.lblCompanyName.text = arrCompanyInfo[indexPath.row].companyName
        cell.lblPrice.text = "$ \(arrCompanyInfo[indexPath.row].price)"

        
        let company = arrCompanyInfo[indexPath.row]
        cell.textLabel?.text = "\(company.symbol) \(company.companyName) \(company.price)"
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            arrCompanyInfo.remove(at: indexPath.row)
            //removeStockFromDB(arrCompanyInfo[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        companyDetail = arrCompanyInfo[indexPath.row]
        performSegue(withIdentifier: "segueDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.companyInfo = companyDetail
        }
    }
}
