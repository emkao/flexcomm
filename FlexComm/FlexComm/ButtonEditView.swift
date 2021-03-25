//
//  ButtonEditView.swift
//  FlexComm
//
//  Created by emily kao on 3/7/21.
//

import SwiftUI

struct ButtonEditView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @StateObject var globals: GlobalVars
    @Binding var selectedButton: Int
    @Binding var editButton: Bool
    @State var btnText: String = ""
    @State private var btnIsFolder: Int = 0
    var isFolderOptions = ["Option", "Folder"]
    
    var body: some View {
        VStack {
            Text("Edit \(currentOptions.options[selectedButton].text)" as String)
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            Form {
                Section(header: Text("Options")) {
                    HStack {
                        Text("Option Text: ")
                        TextField("Enter Option Text", text: $btnText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Picker(selection: $btnIsFolder, label: Text("Option is a ")) {
                        ForEach(0 ..< isFolderOptions.count) {
                            Text(self.isFolderOptions[$0])
                        }
                    }
                }
            }
            .SFProFont(style: .body, weight: .regular, multiplier: globals.multiplier)
            
            HStack {
                Button(action: {
                    self.editButton.toggle()
                }, label: {
                    Text("Cancel")
                })
                .padding(30)
                
                Spacer()
                
                Button(action: {
                    currentOptions.editOption(index: selectedButton, text: btnText)
                    self.editButton.toggle()
                }, label: {
                    Text("Done")
                })
                .padding(30)
            }
        }
        .onAppear(perform: {
            btnText = currentOptions.options[selectedButton].text
            if currentOptions.options[selectedButton].isFolder {
                btnIsFolder = 1
            }
            else {
                btnIsFolder = 0
            }
        })
        Spacer()
    }
}
