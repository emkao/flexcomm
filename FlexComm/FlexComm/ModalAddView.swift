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
    @State private var btnIsFolder: Int = 0
    var isFolderOptions = ["Option", "Folder"]
    
    var body: some View {
        VStack {
            Text("Add Option")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            Form {
                Section(header: Text("Option")) {
                    Picker(selection: $btnIsFolder, label: Text("Option is a ")) {
                        ForEach(0 ..< isFolderOptions.count) {
                            Text(self.isFolderOptions[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Option Text: ")
                        TextField("Enter Option Text", text: $btnText)
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
                    currentOptions.addOption(text: btnText, isFolder: (btnIsFolder == 1))
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
