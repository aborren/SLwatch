//
//  NearbyStationsInterfaceController.swift
//  SLwatch
//
//  Created by Dan Isacson on 04/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation

class NearbyStationsInterfaceController: WKInterfaceController {

    @IBOutlet var testlabel: WKInterfaceLabel!
    @IBOutlet var stationsTable: WKInterfaceTable!
    
    var locationManager: CLLocationManager!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        configureTableWithData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        testlabel.setText("HEJ!")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func configureTableWithData(){
        self.stationsTable.setNumberOfRows(5, withRowType: "rowcontroller")
        for( var i = 0; i < 5; i++){
            var row: RowController = self.stationsTable.rowControllerAtIndex(i) as! RowController
            row.rowDescription.setText(i.description)
        }
    }
}
