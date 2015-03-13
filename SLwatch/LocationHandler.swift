//
//  LocationHandler.swift
//  SLwatch
//
//  Created by Dan Isacson on 05/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var wh: MMWormhole?
    
    override init(){
        self.locationManager = CLLocationManager()
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
    }
    
    func upDateCoordinates(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("failed" + error.description)
    }
    
    //uses wormhole to message receiver with coordinates
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
  
        if let currentLocation = newLocation{
            let response = ["longitude":currentLocation.coordinate.longitude, "latitude":currentLocation.coordinate.latitude]
            self.wh!.passMessageObject(response as NSDictionary, identifier: "location")
            locationManager.stopUpdatingLocation()
        }
    }
    
}