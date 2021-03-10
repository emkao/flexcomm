//
//  ContentView.swift
//  FlexComm
//
//  Created by emily kao on 2/21/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var globals = GlobalVars()
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: nil) {
                Spacer()
                Text("FlexComm")
                    .padding(15)
                    .font(.custom("SFProText-Thin", size: 90))
                NavigationLink(
                    destination: OptionsView(),
                    label: {
                        Text("Start")
                            .font(.custom("SFProText-Thin", size: 35))
                            .padding(5)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(globals)
                    })
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("Settings")
                            .font(.custom("SFProText-Thin", size: 35))
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
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
