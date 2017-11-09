//
//  HistoryViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    var reports: [Report] = Report.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELL_ID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: CELL_ID)
        let report = reports[indexPath.row]
        cell.textLabel?.text = report.keyText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ReportDetails", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReportViewController {
            destination.dateText = reports[(tableView.indexPathForSelectedRow?.row)!].date
            destination.locationText = reports[(tableView.indexPathForSelectedRow?.row)!].locationType
            destination.zipText = reports[(tableView.indexPathForSelectedRow?.row)!].zip
            destination.cityText = reports[(tableView.indexPathForSelectedRow?.row)!].city
            destination.boroughText = reports[(tableView.indexPathForSelectedRow?.row)!].borough
            destination.longitudeText = reports[(tableView.indexPathForSelectedRow?.row)!].longitude
            destination.latitudeText = reports[(tableView.indexPathForSelectedRow?.row)!].latitude
            destination.addressText = reports[(tableView.indexPathForSelectedRow?.row)!].address
            
        }
    }

}
