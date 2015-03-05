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
    
    var wh: MMWormhole?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
        
        self.wh!.listenForMessageWithIdentifier("stations", listener: { (stations) -> Void in
            println(stations)
            self.configureTableWithData(stations as! [String:String])
        })
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let test = 1
        
        self.wh!.passMessageObject(test, identifier: "wk")
        
        testlabel.setText("HEJ!")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func configureTableWithData(stations: [String: String]){
        self.stationsTable.setNumberOfRows(stations.count, withRowType: "rowcontroller")
        /*for( var i = 0; i < stations.count; i++){
            var row: RowController = self.stationsTable.rowControllerAtIndex(i) as! RowController
            row.rowDescription.setText(stations.)
        }*/
        var i = 0
        for station in stations.keys{
            var row: RowController = self.stationsTable.rowControllerAtIndex(i) as! RowController
            row.rowDescription.setText(station)
            i++
        }
    }
}
