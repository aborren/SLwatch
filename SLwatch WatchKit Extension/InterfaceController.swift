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
        
     
        
    }
    @IBOutlet var testt: WKInterfaceSwitch!

    @IBAction func test(value: Bool) {
        println(value)
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
