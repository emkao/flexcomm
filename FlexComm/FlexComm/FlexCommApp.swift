//
//  FlexCommApp.swift
//  FlexComm
//
//  Created by emily kao on 2/21/21.
//

import SwiftUI

@main
struct FlexCommApp: App {
    @State private var openScreen = "home"
    
    var body: some Scene {
        WindowGroup {
            if openScreen == "home" {
                ContentView(openScreen: $openScreen)
            }
            else if openScreen == "start" {
                yesNoView()
            }
            else {
                SettingsView()
            }
        }
    }
}
