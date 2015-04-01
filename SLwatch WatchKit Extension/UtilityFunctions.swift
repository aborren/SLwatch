//
//  UtilityFunctions.swift
//  SLwatch
//
//  Created by Dan Isacson on 16/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import Foundation

class UtilityFunctions{
    class func convertResponseToStations(responseObject: NSDictionary)->[Station]{
        let results : NSDictionary = responseObject["stationsinzoneresult"] as NSDictionary
        var stations: [Station] = []
        if(results.count>0){
            if(results["location"]!.isKindOfClass(NSArray)){
                let locations: NSArray  = results["location"] as NSArray
                for location in locations{
                    let name = location["name"] as String
                    let id = location["@id"] as String
                    let long = location["@x"] as String
                    let lat = location["@y"] as String
                    //println(self.getSLidFromGTFSid(id) + " " + id)
                    let transportTypes = self.getTransportTypesStringFromTransportList(location["transportlist"] as NSDictionary)
                    stations.append(Station(id: id, name: name, transportTypes: transportTypes, x: long, y: lat))
                }
            }
            else if(results["location"]!.isKindOfClass(NSDictionary)){
                let location : NSDictionary = results["location"] as NSDictionary
                let name = location["name"] as String
                let id = location["@id"] as String
                let long = location["@x"] as String
                let lat = location["@y"] as String
                //println(self.getSLidFromGTFSid(id) + " " + id)
                let transportTypes = self.getTransportTypesStringFromTransportList(location["transportlist"] as NSDictionary)
                stations.append(Station(id: id, name: name, transportTypes: transportTypes, x: long, y: lat))
            }
        }
        return stations
    }
    
    class func getTransportTypesStringFromTransportList(transportList: NSDictionary)->String{
        var transportTypes: String = ""
        
        if(transportList.count>0){
            if(transportList["transport"]!.isKindOfClass(NSArray)){
                let transports: NSArray  = transportList["transport"] as NSArray
                for transport in transports{
                    transportTypes += transport["@displaytype"] as String
                }
            }
            else if(transportList["transport"]!.isKindOfClass(NSDictionary)){
                transportTypes = (transportList["transport"] as NSDictionary)["@displaytype"] as String
            }
        }
        
        return transportTypes
    }

    class func convertResponseToDepartures(responseObject: AnyObject, filterString: String)->[Departure]{
        var departures: [Departure] = []
        let json = JSON(responseObject)
        if(json["getdeparturesresult"].count > 0){
            if let segments = json["getdeparturesresult"]["departuresegment"].array {
                for segment in segments {
                    let datetime = segment["departure"]["datetime"].string
                    let direction = segment["direction"].string
                    let linenumber = segment["segmentid"]["carrier"]["number"].string
                    let type = segment["segmentid"]["mot"]["@displaytype"].string
                    
                    let dateFormater = NSDateFormatter()
                    dateFormater.dateFormat = "y-M-dd HH:mm"
                    
                    //adds the departures if it's part of the included types in the filter
                    if let type = type {
                        if let datetime = datetime {
                            if(filterString.rangeOfString(type, options: nil, range: nil, locale: nil) != nil){
                                departures.append(Departure(direction: direction, transportType: type, lineNumber: linenumber, departureTime: dateFormater.dateFromString(datetime)))
                            }
                        }
                    }
                }
            }else if let typeOfSegment = json["getdeparturesresult"]["departuresegment"].dictionary {
                let segment = json["getdeparturesresult"]["departuresegment"]
                let datetime = segment["departure"]["datetime"].string
                let direction = segment["direction"].string
                let linenumber = segment["segmentid"]["carrier"]["number"].string
                let type = segment["segmentid"]["mot"]["@displaytype"].string
                
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "y-M-dd HH:mm"
                
                //adds the departures if it's part of the included types in the filter
                if let type = type {
                    if let datetime = datetime {
                        if(filterString.rangeOfString(type, options: nil, range: nil, locale: nil) != nil){
                            departures.append(Departure(direction: direction, transportType: type, lineNumber: linenumber, departureTime: dateFormater.dateFromString(datetime)))
                        }
                    }
                }
            }
        }
        return departures
    }
}