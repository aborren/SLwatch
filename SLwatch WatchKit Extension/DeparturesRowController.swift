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
 
    func setUpRow(departure: Departure){
        if let line = departure.lineNumber {
            if let direction = departure.direction{
                self.directionLabel.setText("\(line) \(direction)")
            }else{
                self.directionLabel.setText(line)
            }
        }else{
            if let direction = departure.direction{
                self.directionLabel.setText("\(direction)")
            }else{
                self.directionLabel.setText("Unknown destination")
            }
        }
        
        if let departureTime = departure.departureTime {
            var df = NSDateFormatter()
            df.dateFormat = "HH:mm"
            self.timeLabel.setText(df.stringFromDate(departureTime))
        }
    }
}
