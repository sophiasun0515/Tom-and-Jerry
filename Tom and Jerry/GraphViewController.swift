//
//  GraphViewController.swift
//  Tom and Jerry
//
//  Created by Apple on 11/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import ScrollableGraphView

class GraphViewController: UIViewController, ScrollableGraphViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var segmentedSelector: UISegmentedControl!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    var startingYear = 2005
    var endingYear = 2005
    var ref: DatabaseReference! = Database.database().reference()
    var mappingOfYearAndQuantity: [(Int, Int)] = []
    var quantityArr: [Double] = []

//    var mappingofYearAndQuantity : [Int: Int] = [:]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 13
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(2005 + row)"
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
//        return (Double(mappingOfYearAndQuantity[pointIndex].1) / 10000.0)
        return (Double(mappingOfYearAndQuantity[pointIndex].1))
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(mappingOfYearAndQuantity[pointIndex].0)"
    }
    
//    func quantity(atIndex pointIndex: Int) {
//        quantityArr.append(Double(mappingOfYearAndQuantity[pointIndex].1) / 10000.0)
//    }
    
    
    
    
    
    
    
    func numberOfPoints() -> Int {
        return mappingOfYearAndQuantity.count
    }
    
    @IBAction func startQueryingGraph(_ sender: UIButton) {
        queryGraphInformation()
    }
    
    var queries: [Any] = []
    
    func queryGraphInformation() {
        self.mappingOfYearAndQuantity = []
        for currentYear in startingYear..<endingYear + 1 {
            let startFormattedString = "\(currentYear)/01/01 12:00:00 AM"
            let endingFormattedString = "\(currentYear + 1)/01/01 12:00:00 AM"
            
            let query = ref.child("Entries")
                .queryOrdered(byChild: "Created Date")
                .queryStarting(atValue: startFormattedString)
                .queryEnding(atValue: endingFormattedString)
            print("starting and ending format strings are: \(startFormattedString), \(endingFormattedString)")
            queries.append(query)
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    self.mappingOfYearAndQuantity.append((currentYear, value.count))
//                    self.quantityArr.append(Double(value.count) / 10000.0)
                    self.quantityArr.append(Double(value.count))
                    
                    self.configureGraph()
                    if (self.mappingOfYearAndQuantity.count == self.endingYear - self.startingYear + 1) {
                        DispatchQueue.main.async {
                            self.graphView.reload()
                        }
                    }
                    
                }
            })


        }
        
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (segmentedSelector.selectedSegmentIndex == 0) {
            startingYear = 2005 + row
        } else if (segmentedSelector.selectedSegmentIndex == 1) {
            endingYear = 2005 + row
        }
    }
    
    @IBAction func yearSelectionChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if (index == 0) {
            yearPicker.selectRow(startingYear - 2005, inComponent: 0, animated: true)
        } else if (index == 1) {
            yearPicker.selectRow(endingYear - 2005, inComponent: 0, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.delegate = self
        yearPicker.dataSource = self

    }
    
    func configureGraph() {
        graphView.dataSource = self
        // Setup the line plot.
        let linePlot = LinePlot(identifier: "darkLine")
        
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.colorFromHex(hexString: "#777777")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
        linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.positionType = .absolute
        // Reference lines will be shown at these values on the y-axis.
        
        referenceLines.absolutePositions = quantityArr
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        graphView.rangeMax = 50
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
//        self.view.addSubview(graphView)
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

extension UIColor {
    
    // Convert a hex string to a UIColor object.
    class func colorFromHex(hexString hexString:String) -> UIColor {
        
        func cleanHexString(_ hexString: String) -> String {
            
            var cleanedHexString = String()
            
            // Remove the leading "#"
            if(hexString[hexString.startIndex] == "#") {
                cleanedHexString = hexString.substring(from: hexString.index(hexString.startIndex, offsetBy: 1))
            }
            
            // TODO: Other cleanup. Allow for a "short" hex string, i.e., "#fff"
            
            return cleanedHexString
        }
        
        let cleanedHexString = cleanHexString(hexString)
        
        // If we can get a cached version of the colour, get out early.
        if let cachedColor = UIColor.getColorFromCache(cleanedHexString) {
            return cachedColor
        }
        
        // Else create the color, store it in the cache and return.
        let scanner = Scanner(string: cleanedHexString)
        
        var value:UInt32 = 0
        
        // We have the hex value, grab the red, green, blue and alpha values.
        // Have to pass value by reference, scanner modifies this directly as the result of scanning the hex string. The return value is the success or fail.
        if(scanner.scanHexInt32(&value)){
            
            // intValue = 01010101 11110111 11101010    // binary
            // intValue = 55       F7       EA          // hexadecimal
            
            //                     r
            //   00000000 00000000 01010101 intValue >> 16
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 01010101 red
            
            //            r        g
            //   00000000 01010101 11110111 intValue >> 8
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11110111 green
            
            //   r        g        b
            //   01010101 11110111 11101010 intValue
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11101010 blue
            
            let intValue = UInt32(value)
            let mask:UInt32 = 0xFF
            
            let red = intValue >> 16 & mask
            let green = intValue >> 8 & mask
            let blue = intValue & mask
            
            // red, green, blue and alpha are currently between 0 and 255
            // We want to normalise these values between 0 and 1 to use with UIColor.
            let colors:[UInt32] = [red, green, blue]
            let normalised = normaliseColors(colors)
            
            let newColor = UIColor(red: normalised[0], green: normalised[1], blue: normalised[2], alpha: 1)
            UIColor.storeColorInCache(cleanedHexString, color: newColor)
            
            return newColor
            
        }
            // We couldn't get a value from a valid hex string.
        else {
            print("Error: Couldn't convert the hex string to a number, returning UIColor.whiteColor() instead.")
            return UIColor.white
        }
    }
    
    // Takes an array of colours in the range of 0-255 and returns a value between 0 and 1.
    private class func normaliseColors(_ colors: [UInt32]) -> [CGFloat]{
        var normalisedVersions = [CGFloat]()
        
        for color in colors{
            normalisedVersions.append(CGFloat(color % 256) / 255)
        }
        
        return normalisedVersions
    }
    
    // Caching
    // Store any colours we've gotten before. Colours don't change.
    private static var hexColorCache = [String : UIColor]()
    
    private class func getColorFromCache(_ hexString: String) -> UIColor? {
        guard let color = UIColor.hexColorCache[hexString] else {
            return nil
        }
        
        return color
    }
    
    private class func storeColorInCache(_ hexString: String, color: UIColor) {
        
        if UIColor.hexColorCache.keys.contains(hexString) {
            return // No work to do if it is already there.
        }
        
        UIColor.hexColorCache[hexString] = color
    }
    
    private class func clearColorCache() {
        UIColor.hexColorCache.removeAll()
    }
}
