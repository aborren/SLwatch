//
//  ViewController.swift
//  SLwatch
//
//  Created by Dan Isacson on 27/02/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController/*, CLLocationManagerDelegate */{
    @IBOutlet var label: UILabel!
    var locationManager: CLLocationManager!
    var stations: [Station] = []
    var loc = LocationHandler()
    
    var wh: MMWormhole?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")

        self.wh!.listenForMessageWithIdentifier("requestNearbyStations", listener: { (test) -> Void in
            //self.startLocationFinder()
        })

        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()

    }
    
    @IBAction func getLocation(sender: AnyObject) {
        println("klicka")
        locationManager.requestAlwaysAuthorization()
    }
    
    /*func startLocationFinder(){
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }*/
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("failed" + error.description)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
                println("hoi")
        if let currentLocation = newLocation{
            self.label.text = "long =" + currentLocation.coordinate.longitude.description + " lat =" + currentLocation.coordinate.latitude.description
            
            //getLocalStations(currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func getDepartures(sender: AnyObject) {
        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            "https://api.trafiklab.se/samtrafiken/resrobotstops/GetDepartures.json?apiVersion=2.2&coordSys=RT90&locationId=7424928&timeSpan=30&key=TrGAqilPmbAXHY1HpIxGAUkmARCAn4qH",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.wh!.passMessageObject(responseObject as NSDictionary, identifier: "departures")
                println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
            }
        )
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

