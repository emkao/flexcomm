//
//  ContentView.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewController = ViewController()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Basic Chat")
                        .padding()
                    Spacer()
                    Button(action: {
                        viewController.startScanning()
                    }, label: {
                        Text("Scan")
                    })
                    .disabled(viewController.scanningBtnDisabled)
                    .padding()
                }
                Text(viewController.scanningText)
                TableList(viewController: viewController)
                Button(action: {
                    viewController.writeOutgoingValue(data: "Hello World")
                }, label: {
                    Text("hello world")
                })
                .padding(20)
                Spacer()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
