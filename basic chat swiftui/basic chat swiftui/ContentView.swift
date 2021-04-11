//
//  ContentView.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewController = ViewController()
    @State private var message = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    var body: some View {
        if (viewController.changeView == false) {
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
            .onAppear(perform: {
                viewController.loadViewController()
            })
        }
        else {
            VStack {
                Text(viewController.peripheralText)
                Text(viewController.serviceText)
                Text(viewController.txText)
                Text(viewController.rxText)
            }
            .onAppear(perform: {
                viewController.loadConsoleController()
            })
            TextView(text: $message, textStyle: $textStyle)
                .padding(.horizontal)
            TextField(
                "start chatting... ",
                text: $message,
                onEditingChanged: {_ in
                    message = ""
                }, onCommit: {
                    viewController.writeOutgoingValue(data: message)
                    viewController.appendTxDataToTextView()
                    message = ""
            })
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
