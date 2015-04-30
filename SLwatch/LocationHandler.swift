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
    
    func upDateCoordinates()->Bool{
        self.locationManager.requestAlwaysAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.AuthorizedAlways){
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            return true
        }
        return false
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("failed" + error.description)
        self.wh!.passMessageObject(nil, identifier: "failedLocation")
    }
    
    //uses wormhole to message receiver with coordinates
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
  
        if let currentLocation = newLocation{
            let response = ["longitude":currentLocation.coordinate.longitude, "latitude":currentLocation.coordinate.latitude]
            self.wh!.passMessageObject(response as NSDictionary, identifier: "location")
            locationManager.stopUpdatingLocation()
        }else{
            println("lol")
        }
    }
    
}