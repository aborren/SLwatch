//
//  AppDelegate.swift
//  SLwatch
//
//  Created by Dan Isacson on 27/02/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locHandler = LocationHandler()
    var wh: MMWormhole = MMWormhole(applicationGroupIdentifier: "group.slwatch", optionalDirectory: "wormhole")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        let request: String = (userInfo as [String : String])["request"]!
        
        if(request == "stations"){
            self.locHandler.upDateCoordinates()
        }else if(request == "departures"){
            self.apiCallDepartures((userInfo as [String:String])["stationID"]!)
        }
    
        reply(userInfo)
    }

    
    func apiCallDepartures(stationID: String){
        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            "https://api.trafiklab.se/samtrafiken/resrobotstops/GetDepartures.json?apiVersion=2.2&coordSys=RT90&locationId=\(stationID)&timeSpan=30&key=TrGAqilPmbAXHY1HpIxGAUkmARCAn4qH",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.wh.passMessageObject(responseObject as NSDictionary, identifier: "departures")
                println("JSON: " + responseObject.description)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
            }
        )
    }
}

