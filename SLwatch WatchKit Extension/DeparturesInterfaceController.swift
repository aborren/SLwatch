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

    @IBOutlet var stationLabel: WKInterfaceLabel!
    @IBOutlet var departuresTable: WKInterfaceTable!
    @IBOutlet var noDeparturesLabel: WKInterfaceLabel!
    @IBOutlet var loadingImage: WKInterfaceImage!
    
    var departures: [Departure] = []
    var station: Station?
    var filterString: String = ""
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        self.station = context as? Station
        self.stationLabel.setText(self.station!.name)

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadFilterString()
        if let stationID = self.station?.id {
            self.loadingImage.setHidden(false)
            self.noDeparturesLabel.setHidden(true)
            self.departuresTable.setHidden(true)
            request(.GET, "https://api.trafiklab.se/samtrafiken/resrobotstops/GetDepartures.json?apiVersion=2.2&coordSys=RT90&locationId=\(stationID)&timeSpan=30&key=TrGAqilPmbAXHY1HpIxGAUkmARCAn4qH")
                    .responseJSON { (_, _, JSON, error) in
                        if let response: AnyObject = JSON {
                            self.loadingImage.setHidden(true)
                            self.departuresTable.setHidden(false)
                            self.noDeparturesLabel.setHidden(true)
                            self.departures = UtilityFunctions.convertResponseToDepartures(response, filterString: self.filterString)
                            self.configureTableWithData(self.departures)
                        }
                        if let error = error{
                            self.loadingImage.setHidden(true)
                            self.noDeparturesLabel.setHidden(false)
                            self.noDeparturesLabel.setText(NSLocalizedString("SERVER_FAILED", comment: "Hi"))
                        }
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //depracated
    func refreshTableOnDeparture(){
        if(self.departures.count > 0){
            if let refreshDate = self.departures[0].departureTime{
                let t = NSTimer(fireDate: refreshDate.dateByAddingTimeInterval(60.0), interval: 0, target: self, selector: "willActivate", userInfo: nil, repeats: false)
                NSRunLoop.currentRunLoop().addTimer(t, forMode: NSDefaultRunLoopMode)
            }
        }
    }
    
    func configureTableWithData(departures: [Departure]){
        self.departuresTable.setNumberOfRows(departures.count, withRowType: "departuresrowcontroller")
        for(var i = 0; i < departures.count; i++){
            var row: DeparturesRowController = self.departuresTable.rowControllerAtIndex(i) as! DeparturesRowController
            row.setUpRow(departures[i]) 
        }
        
        //if no stations show message
        if(departures.count == 0){
            self.noDeparturesLabel.setText(NSLocalizedString("NO_DEPARTURES_MESSAGE", comment: "no departures"))
            self.noDeparturesLabel.setHidden(false)
        }else{
            self.noDeparturesLabel.setHidden(true)
        }
    }
    
    func loadFilterString(){
        if let filter = self.userDefaults?.stringForKey(self.station!.id){
            self.filterString = filter
        }else{
            self.filterString = self.station!.transportTypes
        }
    }

    
    @IBAction func map() {
        presentControllerWithName("map", context: self.station!)
    }
    
    @IBAction func filter() {
        presentControllerWithName("filter", context: self.station!)
    }

    @IBAction func glance() {
        self.userDefaults?.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.station!), forKey: "glance")
        self.userDefaults?.synchronize()
    }
}
