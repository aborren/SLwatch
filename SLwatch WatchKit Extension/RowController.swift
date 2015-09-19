//
//  RowController.swift
//  SLwatch
//
//  Created by Dan Isacson on 04/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit
import WatchKit

class RowController: NSObject {
    
    var station: Station!
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    @IBOutlet var favouriteButton: WKInterfaceButton!
    @IBOutlet var favouriteButtonImage: WKInterfaceImage!
    
    @IBOutlet weak var rowDescription: WKInterfaceLabel!

    @IBAction func favouritePressed() {
        print("pressed")
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
                self.favouriteButtonImage.setImageNamed("star-50.png")
                //self.favouriteButton.setBackgroundImageNamed("star-50.png")
            }else{
                //lägg till i favoriter o sätt fylld stjärna
                favourites.append(self.station)
                self.userDefaults?.setValue(NSKeyedArchiver.archivedDataWithRootObject(favourites), forKey: "favourites")
                self.favouriteButtonImage.setImageNamed("star_filled-50.png")
                //self.favouriteButton.setBackgroundImageNamed("star_filled-50.png")
            }
        }else{
            self.userDefaults?.setObject(NSKeyedArchiver.archivedDataWithRootObject([self.station]), forKey: "favourites")
            
        }
        self.userDefaults?.synchronize()
    }
}
