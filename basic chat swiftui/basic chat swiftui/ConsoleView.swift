//
//  ConsoleView.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import SwiftUI

struct ConsoleView: View {
    @ObservedObject var consoleController = ConsoleController()
    @State private var message = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    var body: some View {
        VStack {
            Text(consoleController.peripheralText)
            Text(consoleController.serviceText)
            Text(consoleController.txText)
            Text(consoleController.rxText)
        }
        TextView(text: $message, textStyle: $textStyle)
            .padding(.horizontal)
        TextField(
            "start chatting... ",
            text: $message
        )
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField(
            "start chatting... ",
            text: $message,
            onEditingChanged: {_ in
                message = ""
            }, onCommit: {
                consoleController.writeOutgoingValue(data: message)
                consoleController.appendTxDataToTextView()
                message = ""
        })
    }
}

struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleView()
    }
}
