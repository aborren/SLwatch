//
//  Station.swift
//  SLwatch
//
//  Created by Dan Isacson on 04/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation

class Station: NSObject {
    
    var id: String
    var name: String
    var transportTypes: String
    
    init(id : String, name: String, transportTypes: String){
        self.id = id
        self.name = name
        self.transportTypes = transportTypes
    }

}