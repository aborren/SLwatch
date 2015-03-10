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
    
    @IBOutlet weak var rowDescription: WKInterfaceLabel!
    
    @IBAction func favouritePressed() {
        if var favourites: [String] = self.userDefaults?.objectForKey("favourites") as? [String]{
            var isFavouriteStation = false
            for favourite in favourites{
                if(self.station.id == favourite){
                    isFavouriteStation = true
                }
            }
            if(isFavouriteStation){
                //ta bort från favoriter o sätt tom stjärna
                for(var i = 0; i < favourites.count; i++){
                    if(self.station.id == favourites[i]){
                        favourites.removeAtIndex(i)
                    }
                }
                self.userDefaults?.setValue(favourites, forKey: "favourites")
                self.favouriteButton.setBackgroundImageNamed("star-50.png")
            }else{
                //lägg till i favoriter o sätt fylld stjärna
                favourites.append(self.station.id)
                self.userDefaults?.setValue(favourites, forKey: "favourites")
                self.favouriteButton.setBackgroundImageNamed("star_filled-50.png")
            }
        }else{
            self.userDefaults?.setObject([self.station.id], forKey: "favourites")
            
        }
        self.userDefaults?.synchronize()
    }
}
