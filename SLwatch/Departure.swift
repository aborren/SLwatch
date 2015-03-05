//
//  Departure.swift
//  SLwatch
//
//  Created by Dan Isacson on 04/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation

class Departure {
    /**
    Data needed for departures:
    
    Stationname (should only be needed at start)
    Direction (destination name)
    Type (bus, train etc)
    Line number
    Departure time (countdown)
    **/
    
    let direction: String
    let transportType: String
    let lineNumber: Int
    let departureTime: NSDate

    init(direction: String, transportType: String, lineNumber: Int, departureTime: NSDate){
        self.direction = direction
        self.transportType = transportType
        self.lineNumber = lineNumber
        self.departureTime = departureTime
    }
}