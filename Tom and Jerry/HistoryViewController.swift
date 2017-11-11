//
//  HistoryViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HistoryViewController: UITableViewController {
    var reports:[Report] = []
    var ref: DatabaseReference! = Database.database().reference()
    var arrayOfInitialReports:[Int] = [11464394,
                                       15641584,
                                       31614374,
                                       35927676,
                                       28765083,
                                       36908696,
                                       36910927,
                                       36910928,
                                       36910929,
                                       36911066,
                                       36911067,
                                       36911108,
                                       36911109,
                                       36911110,
                                       36911128,
                                       36912108]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for hardcodedReportCode in arrayOfInitialReports {
            ref.child("Entries")
                .child("\(hardcodedReportCode)")
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary,
                        let borough = value["Borough"] as? String,
                        let city = value["City"] as? String,
                        let createdDate = value["Created Date"] as? String,
                        let incidentAddress = value["Incident Address"] as? String,
                        let incidentZip = value["Incident Zip"] as? String,
                        let latitude = value["Latitude"] as? String,
                        let locationType = value["Location Type"] as? String,
                        let longitude = value["Longitude"] as? String
                    {
//                        print(value)
                        let report = Report(key: hardcodedReportCode,
                                            keyText: "\(hardcodedReportCode)",
                            date: createdDate,
                            locationType: locationType,
                            zip: incidentZip,
                            city: city,
                            borough: borough,
                            longitude: longitude,
                            latitude: latitude,
                            address: incidentAddress)
                        self.reports.append(report)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CELL_ID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: CELL_ID)
        let report = reports[indexPath.row]
        cell.textLabel?.text = "\(report.keyText) - \(report.address)"
        cell.detailTextLabel?.text = "\(report.date)"
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
        if let destination = segue.destination as? ReportViewController,
            let selectedRow = (tableView.indexPathForSelectedRow?.row) {
            let report = reports[selectedRow]
            destination.dateText = report.date
            destination.locationText = report.locationType
            destination.zipText = report.zip
            destination.cityText = report.city
            destination.boroughText = report.borough
            destination.longitudeText = report.longitude
            destination.latitudeText = report.latitude
            destination.addressText = report.address
        }
    }

}
