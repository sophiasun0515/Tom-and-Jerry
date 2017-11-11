//
//  Report.swift
//  Tom and Jerry
//
//  Created by Sophia on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Report {
    var key: Int = 0
    var keyText: String = ""
    var date: String = ""
    var locationType: String = ""
    var zip: String = ""
    var city: String = ""
    var borough: String = ""
    var longitude: String = ""
    var latitude: String = ""
    var address: String = ""
    
    let db = Database.database().reference().child("Entries")
    
    init(key: Int, keyText: String, date: String, locationType: String, zip: String, city: String, borough: String, longitude: String, latitude: String, address: String) {
        self.key = key
        self.keyText = keyText
        self.date = date
        self.locationType = locationType
        self.zip = zip
        self.city = city
        self.borough = borough
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
}

    
    
    
//        Report(
//            key: 11464394,
//            keyText: String(key),
//            date: ref.child("Entries").child(keyText).child("Created Date"),
//            locationType: self.ref.child("Entries").child(keyText).child("Location Type"),
//            zip:self.ref.child("Entries").child(keyText).child("Incident Zip"),
//            city:self.ref.child("Entries").child(keyText).child("City"),
//            borough:self.ref.child("Entries").child(keyText).child("Borough"),
//            longitude:self.ref.child("Entries").child(keyText).child("Longitude"),
//            latitude:self.ref.child("Entries").child(keyText).child("Latitude"),
//            address:self.ref.child("Entries").child(keyText).child("Incident Address")
//         ),
//
//
//        Report(
//            key: 15641584,
//            date: self.ref.child("Entries").child(keyText).child("Created Date"),
//            locationType: self.ref.child("Entries").child(keyText).child("Location Type"),
//            zip:self.ref.child("Entries").child(keyText).child("Incident Zip"),
//            city:self.ref.child("Entries").child(keyText).child("City"),
//            borough:self.ref.child("Entries").child(keyText).child("Borough"),
//            longitude:self.ref.child("Entries").child(keyText).child("Longitude"),
//            latitude:self.ref.child("Entries").child(keyText).child("Latitude"),
//            address:self.ref.child("Entries").child(keyText).child("Incident Address")
    

