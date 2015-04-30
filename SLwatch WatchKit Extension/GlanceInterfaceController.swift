//
//  GlanceInterfaceController.swift
//  SLwatch
//
//  Created by Dan Isacson on 13/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class GlanceInterfaceController: WKInterfaceController {

    @IBOutlet var tableLabel: WKInterfaceLabel!
    @IBOutlet var topLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var departuresTable: WKInterfaceTable!
    @IBOutlet var loadingImage: WKInterfaceImage!
    var station: Station?
    var filterString = ""
    var departures: [Departure] = []
    
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
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
        //hämta station
        self.station = self.getGlanceStation()
        
        if let station = self.station {
            self.titleLabel.setText(station.name)
            //for handoff to main app (opens station view)
            self.passStationToMainApp(station)
            self.loadFilterString()
            self.loadingImage.setHidden(false)
            self.tableLabel.setHidden(true)
            self.departuresTable.setHidden(true)
            request(.GET, "https://api.trafiklab.se/samtrafiken/resrobotstops/GetDepartures.json?apiVersion=2.2&coordSys=RT90&locationId=\(station.id)&timeSpan=30&key=TrGAqilPmbAXHY1HpIxGAUkmARCAn4qH")
                .responseJSON { (_, _, JSON, error) in
                    if let response: AnyObject = JSON {
                        self.loadingImage.setHidden(true)
                        self.departuresTable.setHidden(false)
                        self.departures = self.convertResponseToDepartures(response)
                        self.configureTableWithData(self.departures)
                    }
                    if let error = error {
                        self.loadingImage.setHidden(true)
                        self.tableLabel.setHidden(false)
                        self.tableLabel.setText(NSLocalizedString("SERVER_FAILED", comment: "server failed"))
                    }
                    
            }
        }else{
            self.loadingImage.setHidden(true)
            self.topLabel.setText("")
            self.titleLabel.setText(NSLocalizedString("NO_GLANCE_MESSAGE", comment: "no glance set"))
            self.departuresTable.setHidden(true)
            self.tableLabel.setHidden(false)
            self.tableLabel.setText(NSLocalizedString("NO_GLANCE_INSTRUCTION", comment: "no glance instruction"))
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func passStationToMainApp(station: Station){
        let data = NSKeyedArchiver.archivedDataWithRootObject(station)
        updateUserActivity("dna.SLwatch.watchkitextension", userInfo: ["station":data], webpageURL: nil)

    }
    
    func configureTableWithData(departures: [Departure]){
        var numberOfRows = departures.count
        if(numberOfRows > 2){
            numberOfRows = 2
        }else if(numberOfRows == 0){
            self.tableLabel.setHidden(false)
            self.tableLabel.setText(NSLocalizedString("NO_DEPARTURES_MESSAGE", comment: "no deps"))
        }
        
        self.departuresTable.setNumberOfRows(numberOfRows, withRowType: "departuresrowcontroller")
        for(var i = 0; i < numberOfRows; i++){
            var row: DeparturesRowController = self.departuresTable.rowControllerAtIndex(i) as! DeparturesRowController
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
    
    func getGlanceStation()->Station?{
        var glanceStation: Station?
        if let data = self.userDefaults?.objectForKey("glance") as? NSData{
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            glanceStation = unarc.decodeObjectForKey("root") as? Station
        }
        return glanceStation
    }
    
    func loadFilterString(){
        if let filter = self.userDefaults?.stringForKey(self.station!.id){
            self.filterString = filter
        }else{
            self.filterString = self.station!.transportTypes
        }
    }

}
