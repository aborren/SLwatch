//
//  MapInterfaceController.swift
//  SLwatch
//
//  Created by Dan Isacson on 13/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class MapInterfaceController: WKInterfaceController {
    
    @IBOutlet var map: WKInterfaceMap!
    var wh: MMWormhole?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
        
        //wake parent application on iPhone and reques GPS location
        WKInterfaceController.openParentApplication(["request":"location"], reply: {(replyInfo, error) -> Void in
        })
        
        self.wh!.listenForMessageWithIdentifier("location", listener: { (locationResponse) -> Void in
            if let longitude: Double = locationResponse["longitude"] as? Double{
                if let latitude: Double = locationResponse["latitude"] as? Double{
                    let currentLoc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    //self.map.addAnnotation(currentLoc, withPinColor: WKInterfaceMapPinColor.Green)
                    self.map.addAnnotation(currentLoc, withImageNamed: "public-50", centerOffset: CGPoint(x: 0, y: 0))
                    
                    let station = context as! Station
                    let stationLoc = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
                    self.map.addAnnotation(stationLoc, withPinColor: WKInterfaceMapPinColor.Red)
                    
                    let delta = max(abs(stationLoc.latitude - currentLoc.latitude), abs(stationLoc.longitude - currentLoc.longitude)) * 2
                    println(delta)
                    let coordinateSpan = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
                    
                    let midPoint = CLLocationCoordinate2D(latitude: (station.latitude + currentLoc.latitude)/2, longitude: (station.longitude + currentLoc.longitude)/2)
                    self.map.setRegion(MKCoordinateRegionMake(midPoint, coordinateSpan))
                    

                }
            }
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
