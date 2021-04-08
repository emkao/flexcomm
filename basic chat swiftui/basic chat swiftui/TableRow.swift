//
//  TableRow.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import SwiftUI

struct TableRow: View {
    var peripheralText: String
    var rssiText: String
    
    var body: some View {
        HStack {
            Text(peripheralText)
            Text(rssiText)
        }
    }
}

struct TableRow_Previews: PreviewProvider {
    static var peripheralText = ViewController().peripheralText
    static var rssiText = ViewController().rssiText
    
    static var previews: some View {
        TableRow(peripheralText: peripheralText, rssiText: rssiText)
    }
}
