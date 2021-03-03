//
//  FlexCommApp.swift
//  FlexComm
//
//  Created by emily kao on 2/21/21.
//

import SwiftUI
import Firebase

@main
struct FlexCommApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
              FirebaseApp.configure()
              return true
            }
    }
}
