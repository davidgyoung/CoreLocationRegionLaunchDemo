//
//  AppDelegate.swift
//  CoreLocationRegionLaunchDemo
//
//  Created by Young, David on 9/23/21.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    var locationManager: CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if granted {
                NSLog("Notification Enabled Successfully")
            }else{
                NSLog("Notification Enable Error")
            }
        }
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!)
        let region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "myregion")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(satisfying: constraint)
        return true
    }
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        NSLog("Ranged beacons: \(beacons.count)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("locationManager error: (error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        NSLog("locationManager monitoring failure error: (error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("enter")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("exit")

    }

    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        NSLog("didDetermineState: \(state)")
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        var stateString = "unknown"
        if state == .inside {
            stateString = "inside"
        }
        if state == .outside {
            stateString = "outside"
        }
        content.title = "Beacon Region: \(stateString)"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest.init(identifier: "beaconstate", content: content, trigger: nil)

        center.add(request) { (error) in
            NSLog("Error sending notificaiton: \(error)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        
        
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

