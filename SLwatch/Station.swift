//
//  Station.swift
//  SLwatch
//
//  Created by Dan Isacson on 04/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation

class Station {
    
    /**
    Data needed for stations:
    
    Stationname
    Location ID
    **/
    
    let id: String
    let name: String
    
    init(id : String, name: String){
        self.id = id
        self.name = name
    }
    
}