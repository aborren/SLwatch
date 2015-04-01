//
//  NearbyStationsTableViewController.swift
//  SLwatch
//
//  Created by Dan Isacson on 16/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

class NearbyStationsTableViewController: UITableViewController {

    var wh: MMWormhole?
    var locHandler = LocationHandler()
    var stations: [Station] = []
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wh = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")
        self.locHandler.upDateCoordinates()
        
        self.wh!.listenForMessageWithIdentifier("location", listener: { (locationResponse) -> Void in
            if let longitude: Double = locationResponse["longitude"] as? Double{
                if let latitude: Double = locationResponse["latitude"] as? Double{
                    println("got coordinates")
                    self.setUpTableFromLocation(longitude.description, latitude: latitude.description)
                }
            }
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.stations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nearbyStation", forIndexPath: indexPath) as StationTableViewCell

        // Configure the cell...
        (cell.viewWithTag(1) as UILabel).text = self.stations[indexPath.row].name
        
        //ToDO
        /*
        if let data = self.userDefaults?.objectForKey("favourites") as? NSData{
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            let favourites = unarc.decodeObjectForKey("root") as [Station]
            /*for station in favourites{
                if(station.id == stations[indexPath.row].id){
                    println("fav")
                    //cell.starButton.setImage(UIImage(named: "star_filled-50.png"), forState: UIControlState.allZeros)
                }
            }*/
        }*/
        return cell
    }

    func setUpTableFromLocation(longitude: String, latitude: String){
        let radius = 500 //sätt som setting
        request(.GET, "https://api.trafiklab.se/samtrafiken/resrobot/StationsInZone.json?apiVersion=2.1&centerX=\(longitude)&centerY=\(latitude)&radius=\(radius)&coordSys=WGS84&key=T5Jex4dsGQk03VZlXbvmMMC1hMECZNkm")
            .responseJSON { (_, _, JSON, _) in
                if let stationsResponse = JSON as? NSDictionary {
                    self.stations = UtilityFunctions.convertResponseToStations(stationsResponse as NSDictionary)
                    self.tableView.reloadData()
                }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        var departuresView = segue.destinationViewController as DeparturesTableViewController
        let index = self.tableView.indexPathForSelectedRow()!.row
        departuresView.station = self.stations[index]
    }

}
