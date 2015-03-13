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
    var departures: [Departure] = []
    var station: Station?
    var filterString: String = ""
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.station = context as? Station
        self.test.setText(self.station!.name)
        
        if let filter = self.userDefaults?.stringForKey(self.station!.id){
            self.filterString = filter
        }else{
            self.filterString = self.station!.transportTypes
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let stationID = self.station?.id {
            request(.GET, "https://api.trafiklab.se/samtrafiken/resrobotstops/GetDepartures.json?apiVersion=2.2&coordSys=RT90&locationId=\(stationID)&timeSpan=30&key=TrGAqilPmbAXHY1HpIxGAUkmARCAn4qH")
                    .responseJSON { (_, _, JSON, _) in
                        if let response: AnyObject = JSON {
                            self.departures = self.convertResponseToDepartures(response)
                            self.configureTableWithData(self.departures)
                        }
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func configureTableWithData(departures: [Departure]){
        self.departuresTable.setNumberOfRows(departures.count, withRowType: "departuresrowcontroller")
        for(var i = 0; i < departures.count; i++){
            var row: DeparturesRowController = self.departuresTable.rowControllerAtIndex(i) as DeparturesRowController
            row.setUpRow(departures[i]) 
        }
    }
    
    func convertResponseToDepartures(responseObject: AnyObject)->[Departure]{
        var departures: [Departure] = []
        let json = JSON(responseObject)
        if(json["getdeparturesresult"].count > 0){
            if let segments = json["getdeparturesresult"]["departuresegment"].array {
                for segment in segments {
                    let datetime = segment["departure"]["datetime"].string
                    let direction = segment["direction"].string
                    let linenumber = segment["segmentid"]["carrier"]["number"].string
                    let type = segment["segmentid"]["mot"]["@displaytype"].string
                    
                    let dateFormater = NSDateFormatter()
                    dateFormater.dateFormat = "y-M-dd HH:mm"
                    
                    //adds the departures if it's part of the included types in the filter
                    if let type = type {
                        if let datetime = datetime {
                            if(filterString.rangeOfString(type, options: nil, range: nil, locale: nil) != nil){
                                departures.append(Departure(direction: direction, transportType: type, lineNumber: linenumber, departureTime: dateFormater.dateFromString(datetime)))
                            }
                        }
                    }
                }
            }else if let typeOfSegment = json["getdeparturesresult"]["departuresegment"].dictionary {
                let segment = json["getdeparturesresult"]["departuresegment"]
                let datetime = segment["departure"]["datetime"].string
                let direction = segment["direction"].string
                let linenumber = segment["segmentid"]["carrier"]["number"].string
                let type = segment["segmentid"]["mot"]["@displaytype"].string
                
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "y-M-dd HH:mm"
                
                //adds the departures if it's part of the included types in the filter
                if let type = type {
                    if let datetime = datetime {
                        if(filterString.rangeOfString(type, options: nil, range: nil, locale: nil) != nil){
                            departures.append(Departure(direction: direction, transportType: type, lineNumber: linenumber, departureTime: dateFormater.dateFromString(datetime)))
                        }
                    }
                }
            }
        }
        return departures
    }
    
    
    @IBAction func filter() {
        presentControllerWithName("filter", context: self.station!)
    }

}
