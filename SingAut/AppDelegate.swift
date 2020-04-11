//
//  AppDelegate.swift
//  SingAut
//
//  Created by Faizyy on 11/04/20.
//  Copyright © 2020 faiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var listOfRooms: [RoomData] = []
    
    func downloadInitialData() {
        let service = Services()
        service.downloadData(forType: .roomList, withRoom: nil) { (list) in
            
            guard let roomList = list as? [RoomData] else {
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil, userInfo: ["hasData" : false])
                return
            }
            
            self.listOfRooms = roomList
            // Post notification to reload UI
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil, userInfo: ["hasData" : true])
            
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        downloadInitialData()
        
        return true
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

