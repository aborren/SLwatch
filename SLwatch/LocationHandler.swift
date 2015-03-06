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
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("hoi")
        if let currentLocation = newLocation{
            getLocalStations(currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude)
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func getLocalStations(longitude: Double, latitude: Double){
        let radius = 500 //sätt denna som setting senare
        var stationDictionary: [String: String] = [:]
        var stations: [[String]] = []
        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            "https://api.trafiklab.se/samtrafiken/resrobot/StationsInZone.json?apiVersion=2.1&centerX=\(longitude)&centerY=\(latitude)&radius=\(radius)&coordSys=WGS84&key=T5Jex4dsGQk03VZlXbvmMMC1hMECZNkm",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in

                let results : NSDictionary = responseObject["stationsinzoneresult"] as! NSDictionary
                if(results.count>0){
                    if(results["location"]!.isKindOfClass(NSArray)){
                        let locations: NSArray  = results["location"] as! NSArray
                        for location in locations{
                            let name = location["name"] as! String
                            let id = location["@id"] as! String
                            stationDictionary[name] = id
                            stations.append([name, id])
                        }
                    }
                    else if(results["location"]!.isKindOfClass(NSDictionary)){
                        let location : NSDictionary = results["location"] as! NSDictionary
                        let name = location["name"] as! String
                        let id = location["@id"] as! String
                        stationDictionary[name] = id
                        stations.append([name,id])
                    }
                }
                self.wh!.passMessageObject(stations, identifier: "stations")
                //println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
            }
        )
    }

    
    
}