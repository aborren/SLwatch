//
//  ViewController.swift
//  SLwatch
//
//  Created by Dan Isacson on 27/02/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var label: UILabel!
    var locationManager: CLLocationManager!
    var stations: [Station] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()

    }
    
    @IBAction func getLocation(sender: AnyObject) {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("failed" + error.description)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
                println("hoi")
        if let currentLocation = newLocation{
            self.label.text = "long =" + currentLocation.coordinate.longitude.description + " lat =" + currentLocation.coordinate.latitude.description
            
            getLocalStations(currentLocation.coordinate.longitude, latitude: currentLocation.coordinate.latitude)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func getLocalStations(longitude: Double, latitude: Double){
        let radius = 500 //sätt denna som setting senare

        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            "https://api.trafiklab.se/samtrafiken/resrobot/StationsInZone.json?apiVersion=2.1&centerX=\(longitude)&centerY=\(latitude)&radius=\(radius)&coordSys=WGS84&key=T5Jex4dsGQk03VZlXbvmMMC1hMECZNkm",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.stations = []
                let results : NSDictionary = responseObject["stationsinzoneresult"] as! NSDictionary
                if(results.count>0){
                    if(results["location"]!.isKindOfClass(NSArray)){
                        let locations: NSArray  = results["location"] as! NSArray
                        for location in locations{
                            let name = location["name"] as! String
                            let id = location["@id"] as! String
                            self.stations.append(Station(id: id, name: name))
                        }
                    }
                    else if(results["location"]!.isKindOfClass(NSDictionary)){
                        let location : NSDictionary = results["location"] as! NSDictionary
                        let name = location["name"] as! String
                        let id = location["@id"] as! String
                        self.stations.append(Station(id: id, name: name))
                    }
                }
                self.printStations()
                //println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
            }
        )
    }
    
    func printStations(){
        println(self.stations.count)
        var strBuilder: String = ""
        for station in self.stations{
            println(station.name + " id:" + station.id)
            strBuilder += station.name + " id: " + station.id + "\n"
        }
        self.label.text = strBuilder
    }
    
    @IBAction func getDepartures(sender: AnyObject) {
        
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            "https://api.trafiklab.se/samtrafiken/resrobotstops/GetDepartures.json?apiVersion=2.2&coordSys=RT90&locationId=7424928&timeSpan=30&key=TrGAqilPmbAXHY1HpIxGAUkmARCAn4qH",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
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

