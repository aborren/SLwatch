//
//  FavouriteStationsTableViewController.swift
//  SLwatch
//
//  Created by Dan Isacson on 07/04/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

class FavouriteStationsTableViewController: UITableViewController {
    
    var stations: [Station] = []
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.stations = self.getFavouriteStations()
        self.title = NSLocalizedString("FAVOURITE_STATIONS", comment: "Favourite stations")
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
    
    func getFavouriteStations()->[Station]{
        var favourites: [Station] = []
        if let data = self.userDefaults?.objectForKey("favourites") as? NSData{
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            favourites = unarc.decodeObjectForKey("root") as [Station]
        }
        return favourites
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favouriteStation", forIndexPath: indexPath) as StationTableViewCell
        
        (cell.viewWithTag(1) as UILabel).text = self.stations[indexPath.row].name
        cell.station = self.stations[indexPath.row]
        cell.starButton.setImage(UIImage(named: "star_filled-50-1"), forState: UIControlState.Normal)
        return cell
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
