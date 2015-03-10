//
//  FilterInterfaceController.swift
//  SLwatch
//
//  Created by Dan Isacson on 10/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


class FilterInterfaceController: WKInterfaceController {

    @IBOutlet var bussSwitch: WKInterfaceSwitch!
    @IBOutlet var tunnelbanaSwitch: WKInterfaceSwitch!
    @IBOutlet var sparvagnSwitch: WKInterfaceSwitch!
    @IBOutlet var pendeltagSwitch: WKInterfaceSwitch!
    @IBOutlet var farjaSwitch: WKInterfaceSwitch!
    
    var station: Station?
    var transportTypes: String = ""
    var filterString: String = ""
    var userDefaults = NSUserDefaults(suiteName: "group.slwatch")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.station = context as? Station
        self.transportTypes = self.station!.transportTypes
        self.showSwitches(self.transportTypes)
        
        if let filter = userDefaults?.stringForKey(self.station!.id){
            self.filterString = filter
        }else{
            self.filterString = self.transportTypes
        }
        self.setSwitches(self.filterString)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func showSwitches(typesString: String){
        if(typesString.rangeOfString("B", options: nil, range: nil, locale: nil) != nil){
            self.bussSwitch.setHidden(false)
        }
        if(typesString.rangeOfString("U", options: nil, range: nil, locale: nil) != nil){
            self.tunnelbanaSwitch.setHidden(false)
        }
        if(typesString.rangeOfString("S", options: nil, range: nil, locale: nil) != nil){
            self.sparvagnSwitch.setHidden(false)
        }
        if(typesString.rangeOfString("J", options: nil, range: nil, locale: nil) != nil){
            self.pendeltagSwitch.setHidden(false)
        }
        if(typesString.rangeOfString("F", options: nil, range: nil, locale: nil) != nil){
            self.farjaSwitch.setHidden(false)
        }
    }
    
    func setSwitches(filterString: String){
        if(filterString.rangeOfString("B", options: nil, range: nil, locale: nil) != nil){
            self.bussSwitch.setOn(true)
        }
        if(filterString.rangeOfString("U", options: nil, range: nil, locale: nil) != nil){
            self.tunnelbanaSwitch.setOn(true)
        }
        if(filterString.rangeOfString("S", options: nil, range: nil, locale: nil) != nil){
            self.sparvagnSwitch.setOn(true)
        }
        if(filterString.rangeOfString("J", options: nil, range: nil, locale: nil) != nil){
            self.pendeltagSwitch.setOn(true)
        }
        if(filterString.rangeOfString("F", options: nil, range: nil, locale: nil) != nil){
            self.farjaSwitch.setOn(true)
        }
    }

    @IBAction func switchedBuss(value: Bool) {
        self.addOrDeleteFilterLetter(value, letter: "B")
    }
    @IBAction func switchedTunnelbana(value: Bool) {
        self.addOrDeleteFilterLetter(value, letter: "U")
    }
    @IBAction func switchedSparvagn(value: Bool) {
        self.addOrDeleteFilterLetter(value, letter: "S")
    }
    @IBAction func switchedPendeltag(value: Bool) {
        self.addOrDeleteFilterLetter(value, letter: "J")
    }
    @IBAction func switchedFarja(value: Bool) {
        self.addOrDeleteFilterLetter(value, letter: "F")
    }
    
    func addOrDeleteFilterLetter(add: Bool, letter: String){
        if(add){
            self.filterString += letter
        }else{
            self.filterString = self.filterString.stringByReplacingOccurrencesOfString(letter, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        self.userDefaults?.setValue(self.filterString, forKey: self.station!.id)
    }
}