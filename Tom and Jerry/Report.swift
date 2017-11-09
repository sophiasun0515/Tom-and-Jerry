//
//  Report.swift
//  Tom and Jerry
//
//  Created by Sophia on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Report {
    let key: Int
    let keyText: String
    let date: String
    let locationType: String
    let zip: String
    let city: String
    let borough: String
    let longitude: String
    let latitude: String
    let address: String
    
    var ref: DatabaseReference!
    ref = Database.database().reference()
    
    static let all = [
        Report(
            key: 11464394,
            keyText: String(key),
            date: ref.child("Entries").child(keyText).child("Created Date"),
            locationType: self.ref.child("Entries").child(keyText).child("Location Type"),
            zip:self.ref.child("Entries").child(keyText).child("Incident Zip"),
            city:self.ref.child("Entries").child(keyText).child("City"),
            borough:self.ref.child("Entries").child(keyText).child("Borough"),
            longitude:self.ref.child("Entries").child(keyText).child("Longitude"),
            latitude:self.ref.child("Entries").child(keyText).child("Latitude"),
            address:self.ref.child("Entries").child(keyText).child("Incident Address")
         ),
        
        
        Report(
            key: 15641584,
            date: self.ref.child("Entries").child(keyText).child("Created Date"),
            locationType: self.ref.child("Entries").child(keyText).child("Location Type"),
            zip:self.ref.child("Entries").child(keyText).child("Incident Zip"),
            city:self.ref.child("Entries").child(keyText).child("City"),
            borough:self.ref.child("Entries").child(keyText).child("Borough"),
            longitude:self.ref.child("Entries").child(keyText).child("Longitude"),
            latitude:self.ref.child("Entries").child(keyText).child("Latitude"),
            address:self.ref.child("Entries").child(keyText).child("Incident Address")
        )
        
    ]
}
