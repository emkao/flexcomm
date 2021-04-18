//
//  FlexCommApp.swift
//  FlexComm
//
//  Created by emily kao on 2/21/21.
//

import SwiftUI

@main
struct FlexCommApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
