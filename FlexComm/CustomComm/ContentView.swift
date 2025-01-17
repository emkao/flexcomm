//
//  ContentView.swift
//  FlexComm
//
//  Created by emily kao on 2/21/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var globals = GlobalVars()
    @StateObject var currentOptions = CurrentOptions()
    @StateObject var bleController = BLEController()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: nil) {
                Spacer()
                Text("CustomComm")
                    .padding(15)
                    .font(.custom("SFProText-Thin", size: 90))
                NavigationLink(
                    destination: OptionsView(currentOptions: currentOptions, bleController: bleController, globals: globals, options: [])
                            .environment(\.managedObjectContext, viewContext),
                    label: {
                        Text("Start")
                            .font(.custom("SFProText-Thin", size: 35))
                            .padding(5)
                    })
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                NavigationLink(
                    destination: SettingsView(bleController: bleController)
                        .environmentObject(globals),
                    label: {
                        Text("Settings")
                            .font(.custom("SFProText-Thin", size: 35))
                            .padding(.bottom, 15)
                    })
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                Spacer()
                Spacer()
                Spacer()
                NavigationLink(
                    destination: HelpView(),
                    label: {
                        Text("Help")
                            .font(.custom("SFProText-Thin", size: 20))
                    })
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .statusBar(hidden: true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
