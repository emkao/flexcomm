//
//  TableList.swift
//  basic chat swiftui
//
//  Created by emily kao on 4/7/21.
//

import SwiftUI

struct TableList: View {
    @ObservedObject var viewController: ViewController
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<viewController.numPeripherals()) { i in
                    NavigationLink(
                        destination: ConsoleView(),
                        label: {
                            TableRow(peripheralText: viewController.peripheralText, rssiText: viewController.rssiText)
                                .onTapGesture {
                                    viewController.selectPeripheral(index: i)
                                }
                        })
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct TableList_Previews: PreviewProvider {
    static var previews: some View {
        TableList(viewController: ViewController())
    }
}
