//
//  DeparturesInterfaceController.swift
//  SLwatch
//
//  Created by Dan Isacson on 06/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class DeparturesInterfaceController: WKInterfaceController {

    @IBOutlet var test: WKInterfaceLabel!
    @IBOutlet var departuresTable: WKInterfaceTable!
    var wh: MMWormhole?
    var departures: [Departure] = []
    var station: Station?
    var filterString: String = ""
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.station = context as? Station
        self.test.setText(self.station!.name)
        
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
        
        self.wh!.listenForMessageWithIdentifier("departures", listener: { (departuresResponse) -> Void in
            self.departures = self.convertResponseToDepartures(departuresResponse as NSDictionary)
            self.configureTableWithData(self.departures)
        })

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user

        if let filter = self.userDefaults?.stringForKey(self.station!.id){
            self.filterString = filter
        }else{
            self.filterString = self.station!.transportTypes
        }
        WKInterfaceController.openParentApplication(["request":"departures", "stationID":self.station!.id], reply: {(replyInfo, error) -> Void in
        })
        
        super.willActivate()
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func configureTableWithData(departures: [Departure]){
        self.departuresTable.setNumberOfRows(departures.count, withRowType: "departuresrowcontroller")
        for(var i = 0; i < departures.count; i++){
            var row: DeparturesRowController = self.departuresTable.rowControllerAtIndex(i) as DeparturesRowController
            row.directionLabel.setText("\(departures[i].lineNumber) \(departures[i].direction)")
            //row.numberLabel.setText()
            var df = NSDateFormatter()
            df.dateFormat = "HH:mm"
            row.timeLabel.setText(df.stringFromDate(departures[i].departureTime))
        }
    }

    func convertResponseToDepartures(responseObject: NSDictionary)->[Departure]{
        let results : NSDictionary = responseObject["getdeparturesresult"] as NSDictionary
        var departures: [Departure] = []
        if(results.count>0){
            if(results["departuresegment"]!.isKindOfClass(NSArray)){
                let departuresegments: NSArray  = results["departuresegment"] as NSArray
                for departuresegment in departuresegments {
                    let datetime = (departuresegment["departure"] as NSDictionary)["datetime"] as String
                    let direction = departuresegment["direction"] as String
                    
                    let segmentid = departuresegment["segmentid"] as NSDictionary
                    let linenumber = (segmentid["carrier"] as NSDictionary)["number"] as String
                    let type = (segmentid["mot"] as NSDictionary)["@displaytype"] as String
                    
                    let dateFormater = NSDateFormatter()
                    dateFormater.dateFormat = "y-M-dd HH:mm"
                    
                    //adds the departures if it's part of the included types in the filter
                    if(filterString.rangeOfString(type, options: nil, range: nil, locale: nil) != nil){
                        departures.append(Departure(direction: direction, transportType: type, lineNumber: linenumber, departureTime: dateFormater.dateFromString(datetime)!))
                    }

                }
            }
            else if(results["departuresegment"]!.isKindOfClass(NSDictionary)){
                //not sure if this can happen (no documentation for the api)
            }
        }
        return departures
    }
    @IBAction func filter() {
        presentControllerWithName("filter", context: self.station!)
    }

}
