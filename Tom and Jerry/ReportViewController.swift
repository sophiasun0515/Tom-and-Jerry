//
//  ReportViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ReportViewController: UIViewController {

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var zip: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var borough: UILabel!
    
    @IBOutlet weak var longitude: UILabel!
    
    @IBOutlet weak var latitude: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    var dateText: String?
    var locationText: String?
    var zipText: String?
    var cityText: String?
    var boroughText: String?
    var longitudeText: String?
    var latitudeText: String?
    var addressText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.text = dateText
        location.text = locationText
        zip.text = zipText
        city.text = cityText
        borough.text = boroughText
        longitude.text = longitudeText
        latitude.text = latitudeText
        address.text = addressText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
