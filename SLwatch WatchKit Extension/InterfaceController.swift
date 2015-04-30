//
//  InterfaceController.swift
//  SLwatch WatchKit Extension
//
//  Created by Dan Isacson on 27/02/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //Required to use Station in both extension and main application
        NSKeyedUnarchiver.setClass(Station.self, forClassName: "Station")
        NSKeyedArchiver.setClassName("Station", forClass: Station.self)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
        NSKeyedUnarchiver.setClass(Station.self, forClassName: "Station")
        NSKeyedArchiver.setClassName("Station", forClass: Station.self)
        
        if let data = userInfo?["station"] as? NSData{
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let station = unarc.decodeObjectForKey("root") as? Station
            pushControllerWithName("departuresView", context: station)
        }
    }

}
