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
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: nil) {
                Spacer()
                Text("CustomComm")
                    .padding(15)
                    //.font(.custom("SFProText-Thin", size: CGFloat(90 * GlobalVars_Unifier.multiplier_unifier )))
                    .font(.custom("SFProText-Thin", size: 90))
                NavigationLink(
                    destination: OptionsView(currentOptions: currentOptions, bleController: bleController, globals: globals),
                    label: {
                        Text("Start")
                            .font(.custom("SFProText-Thin", size: 35 ))
                            .padding(5)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(globals)
                    })
                NavigationLink(
                    destination: SettingsView()
                        .environmentObject(bleController)
                        .environmentObject(globals),
                    label: {
                        Text("Settings")
                            .font(.custom("SFProText-Thin", size: 35))
//                            .navigationBarTitle(Text("Settings"), displayMode: .large)
//                            .navigationViewStyle(StackNavigationViewStyle())
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
//                            .edgesIgnoringSafeArea(.all)
                            .environmentObject(globals)
                    })
                Spacer()
                Spacer()
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
