//
//  StationTableViewCell.swift
//  SLwatch
//
//  Created by Dan Isacson on 16/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet var starButton: UIButton!
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    var station: Station!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favouriteBtnPressed(sender: AnyObject) {
        println("pressed")
  
        if let data = self.userDefaults?.objectForKey("favourites") as? NSData{
            var isFavouriteStation = false
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            var favourites = unarc.decodeObjectForKey("root") as! [Station]
            
            for favourite in favourites{
                if(self.station.id == favourite.id){
                    isFavouriteStation = true
                }
            }
            if(isFavouriteStation){
                //ta bort från favoriter o sätt tom stjärna
                for(var i = 0; i < favourites.count; i++){
                    if(self.station.id == favourites[i].id){
                        favourites.removeAtIndex(i)
                    }
                }
                self.userDefaults?.setValue(NSKeyedArchiver.archivedDataWithRootObject(favourites), forKey: "favourites")
                self.starButton.setImage(UIImage(named: "star-50-1"), forState: UIControlState.Normal)
            }else{
                //lägg till i favoriter o sätt fylld stjärna
                favourites.append(self.station)
                self.userDefaults?.setValue(NSKeyedArchiver.archivedDataWithRootObject(favourites), forKey: "favourites")
                self.starButton.setImage(UIImage(named: "star_filled-50-1"), forState: UIControlState.Normal)
            }
        }else{
            self.userDefaults?.setObject(NSKeyedArchiver.archivedDataWithRootObject([self.station]), forKey: "favourites")
            
        }
        self.userDefaults?.synchronize()

    }
}
