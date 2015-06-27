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
    var locHandler = LocationHandler()
    var wh: MMWormhole?
    var stations: [Station] = []
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    @IBOutlet var informationLabel: WKInterfaceLabel!
    @IBOutlet var loadingImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
                
        if(!self.locHandler.upDateCoordinates()){
            self.informationLabel.setHidden(false)
            self.informationLabel.setText(NSLocalizedString("NO_GPS_MESSAGE", comment: "Hi"))
            self.loadingImage.setHidden(true)
        }
        
        
        var didReceiveLocation = false
        self.wh!.listenForMessageWithIdentifier("location", listener: { (locationResponse) -> Void in
            if let longitude: Double = locationResponse["longitude"] as? Double{
                if let latitude: Double = locationResponse["latitude"] as? Double{
                    if(!didReceiveLocation){
                        didReceiveLocation = true
                        self.informationLabel.setHidden(true)
                        self.setUpTableFromLocation(longitude.description, latitude: latitude.description)
                    }
                }
            }
        })
        self.wh!.listenForMessageWithIdentifier("failedLocation", listener: { (locationResponse) -> Void in
            self.loadingImage.setHidden(true)
            self.informationLabel.setHidden(false)
            self.informationLabel.setText(NSLocalizedString("FAILED_LOCATION", comment: "Hi"))
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
            var row: RowController = self.stationsTable.rowControllerAtIndex(i) as! RowController
            row.rowDescription.setText(stations[i].name)
            row.station = stations[i]
            
            if let data = self.userDefaults?.objectForKey("favourites") as? NSData{
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                let favourites = unarc.decodeObjectForKey("root") as! [Station]
                for station in favourites{
                    if(station.id == stations[i].id){
                        row.favouriteButtonImage.setImageNamed("star_filled-50.png")
                    }
                }
            }
        }
        if(stations.count == 0){
            self.informationLabel.setHidden(false)
            self.informationLabel.setText(NSLocalizedString("NO_NEARBYSTATIONS_MESSAGE", comment: "No nearby stations"))
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.stations[rowIndex]
    }
    
    func setUpTableFromLocation(longitude: String, latitude: String){
        println("got coordinates")
        let radius = 500 //sätt som setting
        request(.GET, "https://api.trafiklab.se/samtrafiken/resrobot/StationsInZone.json?apiVersion=2.1&centerX=\(longitude)&centerY=\(latitude)&radius=\(radius)&coordSys=WGS84&key=T5Jex4dsGQk03VZlXbvmMMC1hMECZNkm")
            .responseJSON { (_, _, JSON, error) in
                if let stationsResponse = JSON as? NSDictionary {
                    self.stations = UtilityFunctions.convertResponseToStations(stationsResponse as NSDictionary)
                    self.configureTableWithData(self.stations)
                    self.loadingImage.setHidden(true)
                }
                if let error = error{
                    self.loadingImage.setHidden(true)
                    self.informationLabel.setHidden(false)
                    self.informationLabel.setText(NSLocalizedString("SERVER_FAILED", comment: "Hi"))
                }
        }
    }
}
