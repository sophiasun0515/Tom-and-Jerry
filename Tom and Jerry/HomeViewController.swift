//
//  HomeViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    var ref: DatabaseReference! = Database.database().reference()
    var startingDate: Date = Date.init()
    var endingDate: Date = Date.init()
    
    var extraReportsToPassThrough: [Report] = []
    
    @IBAction func logoutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBOutlet weak var datePickerItself: UIDatePicker!
    @IBOutlet weak var datePickerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView

    }
    
    func queryMapInformation(_ startingDate: Date, endingDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startFormattedString = formatter.string(from: startingDate) + " 12:00:00 AM"
        let endingDateFormattedString = formatter.string(from: endingDate) + " 12:00:00 AM"
        
        let query = ref.child("Entries")
            .queryOrdered(byChild: "Created Date")
            .queryStarting(atValue: startFormattedString)
            .queryEnding(atValue: endingDateFormattedString)
        
        query.observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                DispatchQueue.main.async {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    for (_, addValue) in value {
                        print("we get back \(addValue)")
                        
                        if let subValue = addValue as? NSDictionary,
                            let cityName = subValue["City"] as? String,
                            let latitute = subValue["Latitude"] as? String,
                            let longitude = subValue["Longitude"] as? String,
                            let address = subValue["Incident Address"] as? String,
                            let date = subValue["Created Date"] as? String,
                            let locationType = subValue["Location Type"] as? String,
                            let doubleLatitute = Double(latitute),
                            let doubleLongitude = Double(longitude) {
                            let pin = CustomAnnotation(name: cityName, coordinate: CLLocationCoordinate2D(latitude: doubleLatitute, longitude: doubleLongitude), title: address, subtitle: "\(date), \(locationType)")
                            self.self.mapView.addAnnotation(pin)
                        }
                    }

                }
            }
        }
    }
    
    @IBAction func pickDate(_ sender: Any) {
        datePickerContainer.isHidden = !datePickerContainer.isHidden
    }
    
    @IBAction func dismissDatePicker(_ sender: Any) {
        datePickerContainer.isHidden = true
        queryMapInformation(startingDate, endingDate: endingDate)
    }
    
    @IBAction func datePickerSegmentChanged(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            datePickerItself.date = startingDate
        } else {
            datePickerItself.date = endingDate
        }
    }
    
    @IBAction func datePickerItselfChanged(_ sender: UIDatePicker) {
        if (datePickerSegmentedControl.selectedSegmentIndex == 0) {
            startingDate = sender.date
        } else {
            endingDate = sender.date
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newVC = segue.destination as? NewReportViewController {
            newVC.didAddReport = { [weak self](report) in
                if let vc = self {
                    self?.extraReportsToPassThrough.append(report)
                }
            }
        }
        if let historyVC = segue.destination as? HistoryViewController {
            print(extraReportsToPassThrough)
            for report in extraReportsToPassThrough {
                historyVC.reports.append(report)
            }
        }
    }

}

class CustomAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String = ""
    var title: String?
    var subtitle: String?
    
    init(name: String, coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.name = name
        self.title = title
        self.subtitle = subtitle
    }
}
