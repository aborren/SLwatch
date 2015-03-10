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
    
    init(id : String, name: String, transportTypes: String){
        self.id = id
        self.name = name
        self.transportTypes = transportTypes
    }
    
    required init(coder aDecoder: NSCoder) {
        if let id = aDecoder.decodeObjectForKey("id") as? String {
            self.id = id
        }
        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
        if let transportTypes = aDecoder.decodeObjectForKey("transportTypes") as? String {
            self.transportTypes = transportTypes
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
    }

}