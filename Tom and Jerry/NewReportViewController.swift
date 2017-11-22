//
//  NewReportViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewReportViewController: UIViewController {

    @IBOutlet weak var DateField: UITextField!
    
    @IBOutlet weak var LocationTypeField: UITextField!
    
    @IBOutlet weak var ZipField: UITextField!
    
    
    @IBOutlet weak var CityField: UITextField!
    
    
    @IBOutlet weak var BoroughField: UITextField!
    
    
    @IBOutlet weak var LongitudeField: UITextField!
    
    @IBOutlet weak var LatitudeField: UITextField!
    
    
    @IBOutlet weak var AddressField: UITextField!
    
    var ref: DatabaseReference =
        Database.database().reference()
    
    var didAddReport: ((_ report: Report) -> Void)?
    
    @IBAction func addReportAction(_ sender: Any?) {
        guard let dateText = self.DateField?.text,
            let locationText = self.LocationTypeField?.text,
            let zipText = self.ZipField?.text,
            let cityText = self.CityField?.text,
            let boroughText = self.BoroughField?.text,
            let longitudeText = self.LongitudeField?.text,
            let latitudeText = self.LatitudeField?.text,
            let addressText = self.AddressField?.text
        else {
            return
        }
        if (dateText.isEmpty || locationText.isEmpty || zipText.isEmpty || cityText.isEmpty || boroughText.isEmpty || longitudeText.isEmpty || latitudeText.isEmpty || addressText.isEmpty) {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all the required fields.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            success(message: "Report Added successfully!")
            var completionHandler = ref.child("IDcounter").child("counter").observeSingleEvent(of: .value, with: { (snapshot) in
//
                if let keyValueData = snapshot.value as? Int {
                    print("keyValueData: \(keyValueData)")
                    var keyValue = getNumber(number:keyValueData).intValue + 1
                    let keyValueText = String(describing: keyValue)
                    print("keyValueText: \(keyValueText)")
                    
                    let newReport = Report(key: keyValue, keyText: keyValueText, date: (self.DateField?.text)!, locationType: (self.LocationTypeField?.text)!, zip: (self.ZipField?.text)!, city: (self.CityField?.text)!, borough: (self.BoroughField?.text)!, longitude: (self.LongitudeField?.text)!, latitude: (self.LatitudeField?.text)!, address: (self.AddressField?.text)!)
                    
                    self.didAddReport?(newReport)
                    
                    //Update the counter
                    self.ref.child("IDcounter").child("counter").setValue(keyValue)
                    
                    //Update reports on firebase
                    self.ref.child("Entries").child(keyValueText).child("Create Date").setValue(self.DateField?.text)
                    self.ref.child("Entries").child(keyValueText).child("Borough").setValue(self.BoroughField?.text)
                    self.ref.child("Entries").child(keyValueText).child("Latitude").setValue(self.LatitudeField?.text)
                    self.ref.child("Entries").child(keyValueText).child("Incident Zip").setValue(self.ZipField?.text)
                    self.ref.child("Entries").child(keyValueText).child("City").setValue(self.CityField?.text)
                    self.ref.child("Entries").child(keyValueText).child("Longitude").setValue(self.LongitudeField?.text)
                    self.ref.child("Entries").child(keyValueText).child("Location Type").setValue(self.LocationTypeField?.text)


                }
            })
            
        }

    }
    
    func success(message: String) {
        let alertSuccess = UIAlertController(title: "Listo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertSuccess.addAction(okAction)
        
        self.present(alertSuccess, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard as (UIViewController) -> () -> ()))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

func getNumber(number: Any?) -> NSNumber {
    guard let statusNumber:NSNumber = number as? NSNumber else
    {
        guard let statString:String = number as? String else
        {
            return 0
        }
        if let myInteger = Int(statString)
        {
            return NSNumber(value:myInteger)
        }
        else{
            return 0
        }
    }
    return statusNumber
}
