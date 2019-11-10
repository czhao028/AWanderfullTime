//
//  AppDelegate.swift
//  crime Aid
//
//  Created by Cassy on 11/9/19.
//  Copyright © 2019 Cassy. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var LocationsDB : DatabaseReference!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.LocationsDB = Database.database().reference()
        GMSServices.provideAPIKey("AIzaSyDRlXWYYAMJfS-_CdG_x-pCqOhULYuF29E")
        GMSPlacesClient.provideAPIKey("AIzaSyDvu7RHvyGmakVh3r2jdo-HBh7KjhlsopE")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }


}

