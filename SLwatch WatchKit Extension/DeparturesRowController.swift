//
//  DeparturesRowController.swift
//  SLwatch
//
//  Created by Dan Isacson on 06/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit
import WatchKit

class DeparturesRowController: NSObject {
    @IBOutlet var directionLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var lineNumberLabel: WKInterfaceLabel!
    
    @IBOutlet var departureTypeGroup: WKInterfaceGroup!
    @IBOutlet var departureTypeColorSeparator: WKInterfaceSeparator!
    @IBOutlet var departureTypeLabel: WKInterfaceLabel!
 
    func setUpRow(departure: Departure){
        if let line = departure.lineNumber {
            self.lineNumberLabel.setText(line)

        }else{
            self.lineNumberLabel.setText("")
        }
        
        if let direction = departure.direction{
            self.directionLabel.setText("\(direction)")
        }else{
            self.directionLabel.setText("")
        }
        
        if let departureTime = departure.departureTime {
            self.setUpTime(departureTime)
        }else{
            self.timeLabel.setText("")
        }
        
        if let departureType = departure.transportType, linenumber = departure.lineNumber {
            self.setupTypeLogo(departureType, linenumber: linenumber)
        }else{
            self.departureTypeGroup.setHidden(true)
        }
        
        println(departure.transportType)
    }
    
    func setupTypeLogo(type: String, linenumber: String){
        switch type{
            //"BUSFJ"
        case "U":
            self.departureTypeLabel.setText("T")
            self.setupMetroColor(linenumber)
        case "B":
            self.departureTypeLabel.setText("B")
            self.departureTypeColorSeparator.setColor(UIColor(red: 203/255, green: 49/255, blue: 46/255, alpha: 1))
        case "S":
            self.departureTypeLabel.setText("S")
            self.departureTypeColorSeparator.setColor(UIColor(red: 0/255, green: 172/255, blue: 241/255, alpha: 1))
        case "J":
            self.departureTypeLabel.setText("J")
            self.departureTypeColorSeparator.setColor(UIColor(red: 0/255, green: 172/255, blue: 241/255, alpha: 1))
        case "F":
            self.departureTypeLabel.setText("F")
        default:
            self.departureTypeLabel.setText("")
        }
    }
    
    func setupMetroColor(linenumber: String){
        switch linenumber{
        case "17","18","19":
            self.departureTypeColorSeparator.setColor(UIColor(red: 64/255, green: 128/255, blue: 0, alpha: 1))
        case "13","14":
            self.departureTypeColorSeparator.setColor(UIColor(red: 203/255, green: 49/255, blue: 46/255, alpha: 1))
        case "10","11":
            self.departureTypeColorSeparator.setColor(UIColor(red: 0/255, green: 172/255, blue: 241/255, alpha: 1))
        default:
            self.departureTypeColorSeparator.setColor(UIColor.whiteColor())
        }
    }
    
    func setUpTime(departureTime: NSDate){
        var df = NSDateFormatter()
        df.dateFormat = "HH:mm"
        self.timeLabel.setText(df.stringFromDate(departureTime))
    }
}
