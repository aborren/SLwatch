//
//  FavouritesInterfaceController.swift
//  SLwatch
//
//  Created by Dan Isacson on 10/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class FavouritesInterfaceController: WKInterfaceController {

    @IBOutlet var stationsTable: WKInterfaceTable!
    var stations: [Station] = []
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.stations = self.getFavouriteStations()
        self.configureTableWithData(self.stations)
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

    func getFavouriteStations()->[Station]{
        var favourites: [Station] = []
        if let data = self.userDefaults?.objectForKey("favourites") as? NSData{
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            favourites = unarc.decodeObjectForKey("root") as! [Station]
        }
        return favourites
    }
    
    func configureTableWithData(stations: [Station]){
        self.stationsTable.setNumberOfRows(stations.count, withRowType: "rowcontroller")
        for(var i = 0; i < stations.count; i++){
            var row: RowController = self.stationsTable.rowControllerAtIndex(i) as! RowController
            row.rowDescription.setText(stations[i].name)
            row.station = stations[i]
            row.favouriteButtonImage.setImageNamed("star_filled-50.png")
            //row.favouriteButton.setBackgroundImageNamed("star_filled-50.png")
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.stations[rowIndex]
    }
}
