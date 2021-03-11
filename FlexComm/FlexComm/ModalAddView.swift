//
//  ModalAddView.swift
//  FlexComm
//
//  Created by emily kao on 3/5/21.
//

import SwiftUI

struct ModalAddView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
  //  @EnvironmentObject var globals_old
    @StateObject var globals = GlobalVars()
    @Binding var showAddModal: Bool
    @State private var btnText: String = ""
    
    var body: some View {
        VStack {
            Text("Add Button")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            Form {
                Section(header: Text("Button Options")) {
                    HStack {
                        Text("Button Text: ")
                        TextField("Enter Button Text", text: $btnText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .SFProFont(style: .body, weight: .regular, multiplier: globals.multiplier)
            
            HStack {
                Button(action: {
                    self.showAddModal.toggle()
                }, label: {
                    Text("Cancel")
                })
                .padding(30)
                
                Spacer()
                
                Button(action: {
                    currentOptions.addOption(text: btnText)
                    self.showAddModal.toggle()
                }, label: {
                    Text("Add")
                })
                .padding(30)
            }
        }
        Spacer()
    }
}
