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
    @IBOutlet var nearbyButton: UIButton!
    @IBOutlet var favouriteButton: UIButton!
    
    
    var locationManager: CLLocationManager!
    var stations: [Station] = []
    var loc = LocationHandler()
    
    var wh: MMWormhole?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        self.style()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func style(){
        self.nearbyButton.layer.cornerRadius = 10
        self.favouriteButton.layer.cornerRadius = 10
    }

}

