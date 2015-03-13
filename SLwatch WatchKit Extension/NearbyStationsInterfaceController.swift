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

    @IBOutlet var stationsTable: WKInterfaceTable!
    var locationManager: CLLocationManager!
    var wh: MMWormhole?
    var stations: [Station] = []
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
        
        //wake parent application on iPhone and reques GPS location
        WKInterfaceController.openParentApplication(["request":"stations"], reply: {(replyInfo, error) -> Void in
        })
        
        
        self.wh!.listenForMessageWithIdentifier("location", listener: { (locationResponse) -> Void in
            if let longitude: Double = locationResponse["longitude"] as? Double{
                if let latitude: Double = locationResponse["latitude"] as? Double{
                    self.setUpTableFromLocation(longitude.description, latitude: latitude.description)
                }
            }
        })
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func configureTableWithData(stations: [Station]){
        self.stationsTable.setNumberOfRows(stations.count, withRowType: "rowcontroller")
        for(var i = 0; i < stations.count; i++){
            var row: RowController = self.stationsTable.rowControllerAtIndex(i) as RowController
            row.rowDescription.setText(stations[i].name)
            row.station = stations[i]
            
            if let data = self.userDefaults?.objectForKey("favourites") as? NSData{
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let favourites = unarc.decodeObjectForKey("root") as [Station]
                for station in favourites{
                    if(station.id == stations[i].id){
                        row.favouriteButton.setBackgroundImageNamed("star_filled-50.png")
                    }
                }
            }
        }
    }
    
    func convertResponseToStations(responseObject: NSDictionary)->[Station]{
        let results : NSDictionary = responseObject["stationsinzoneresult"] as NSDictionary
        var stations: [Station] = []
        if(results.count>0){
            if(results["location"]!.isKindOfClass(NSArray)){
                let locations: NSArray  = results["location"] as NSArray
                for location in locations{
                    let name = location["name"] as String
                    let id = location["@id"] as String
                    //println(self.getSLidFromGTFSid(id) + " " + id)
                    let transportTypes = getTransportTypesStringFromTransportList(location["transportlist"] as NSDictionary)
                    stations.append(Station(id: id, name: name, transportTypes: transportTypes))
                }
            }
            else if(results["location"]!.isKindOfClass(NSDictionary)){
                let location : NSDictionary = results["location"] as NSDictionary
                let name = location["name"] as String
                let id = location["@id"] as String
                //println(self.getSLidFromGTFSid(id) + " " + id)
                let transportTypes = getTransportTypesStringFromTransportList(location["transportlist"] as NSDictionary)
                stations.append(Station(id: id, name: name, transportTypes: transportTypes))
            }
        }
        return stations
    }
    
    func getTransportTypesStringFromTransportList(transportList: NSDictionary)->String{
        var transportTypes: String = ""
        
        if(transportList.count>0){
            if(transportList["transport"]!.isKindOfClass(NSArray)){
                let transports: NSArray  = transportList["transport"] as NSArray
                for transport in transports{
                    transportTypes += transport["@displaytype"] as String
                }
            }
            else if(transportList["transport"]!.isKindOfClass(NSDictionary)){
                transportTypes = (transportList["transport"] as NSDictionary)["@displaytype"] as String
            }
        }
        
        return transportTypes
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.stations[rowIndex]
    }
    
    func setUpTableFromLocation(longitude: String, latitude: String){
        let radius = 500 //sätt som setting
        request(.GET, "https://api.trafiklab.se/samtrafiken/resrobot/StationsInZone.json?apiVersion=2.1&centerX=\(longitude)&centerY=\(latitude)&radius=\(radius)&coordSys=WGS84&key=T5Jex4dsGQk03VZlXbvmMMC1hMECZNkm")
            .responseJSON { (_, _, JSON, _) in
                if let stationsResponse = JSON as? NSDictionary {
                    self.stations = self.convertResponseToStations(stationsResponse as NSDictionary)
                    self.configureTableWithData(self.stations)
                }
                println(JSON)
        }
    }
    
    func getSLidFromGTFSid(gtfsId: String)->String{
        //if let url = NSURL(string: "mtr-station.csv") {
        if let url = NSBundle.mainBundle().URLForResource("mtr-station", withExtension:"csv") {
            var error: NSErrorPointer = nil
            if let csv = CSV(contentsOfURL: url, error: error) {
                // Rows
                let rows = csv.rows
                let headers = csv.headers  //=> [slid, gtfsid, gtfsnamn, stationsnamn, pageurl, mapurl]
                for row in rows {
                    if(row["gtfsid"] == gtfsId){
                        return row["slid"]!
                    }
                }
            }
        }
        if let url = NSBundle.mainBundle().URLForResource("sl-gtfs", withExtension:"csv") {
            var error: NSErrorPointer = nil
            if let csv = CSV(contentsOfURL: url, error: error) {
                // Rows
                let rows = csv.rows
                let headers = csv.headers  //=> [SiteID;GTFSID]
                for row in rows {
                    if(row["GTFSID"] == gtfsId){
                        return row["SiteID"]!
                    }
                }
            }
        }
        
        return ""
    }
    
}
