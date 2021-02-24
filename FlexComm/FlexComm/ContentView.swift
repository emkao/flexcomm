//
//  ContentView.swift
//  FlexComm
//
//  Created by emily kao on 2/21/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var openScreen: String
    
    var body: some View {
        VStack {
            Text("FlexComm")
                .padding()
            Button(action: {
                self.openScreen = "start"
            }) {
                Text("Start")
            }
            Button(action: {
                self.openScreen = "settings"
            }) {
                Text("Settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(openScreen: .constant("home"))
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
