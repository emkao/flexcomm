//
//  ModalAddView.swift
//  FlexComm
//
//  Created by emily kao on 3/5/21.
//

import SwiftUI

struct ModalAddView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @Binding var showAddModal: Bool
    @State private var btnText: String = ""
    
    var body: some View {
        VStack {
            Text("Add Button")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            Form {
                Section(header: Text("Button Options")) {
                    TextField("Enter Button Text", text: $btnText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .SFProFont(style: .body, weight: .regular)
            
            HStack {
                Button(action: {
                    print("close form")
                    self.showAddModal.toggle()
                }, label: {
                    Text("Close")
                })
                .padding(30)
                
                Spacer()
                
                Button(action: {
                    print("add button from form")
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
