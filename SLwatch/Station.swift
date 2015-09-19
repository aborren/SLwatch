//
//  Station.swift
//  SLwatch
//
//  Created by Dan Isacson on 04/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation

class Station: NSObject, NSCoding {
    
    var id: String!
    var name: String!
    var transportTypes: String!
    var longitude: Double!
    var latitude: Double!
    
    init(id : String, name: String, transportTypes: String, x: String, y: String){
        self.id = id
        self.name = name
        self.transportTypes = transportTypes
        self.longitude = (x as NSString).doubleValue
        self.latitude = (y as NSString).doubleValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let id = aDecoder.decodeObjectForKey("id") as? String {
            self.id = id
        }
        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
        if let transportTypes = aDecoder.decodeObjectForKey("transportTypes") as? String {
            self.transportTypes = transportTypes
        }
        if let x = aDecoder.decodeObjectForKey("longitude") as? Double {
            self.longitude = x
        }
        if let y = aDecoder.decodeObjectForKey("latitude") as? Double {
            self.latitude = y
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encodeObject(id, forKey: "id")
        }
        if let name = self.name {
            aCoder.encodeObject(name, forKey: "name")
        }
        if let transportTypes = self.transportTypes {
            aCoder.encodeObject(transportTypes, forKey: "transportTypes")
        }
        if let id = self.longitude {
            aCoder.encodeObject(id, forKey: "longitude")
        }
        if let id = self.latitude {
            aCoder.encodeObject(id, forKey: "latitude")
        }
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }

}