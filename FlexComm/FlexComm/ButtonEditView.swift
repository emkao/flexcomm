//
//  ButtonEditView.swift
//  FlexComm
//
//  Created by emily kao on 3/7/21.
//

import SwiftUI

struct ButtonEditView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @Binding var selectedButton: Int
    @Binding var editButton: Bool
    @State var btnText: String = ""
    
    var body: some View {
        VStack {
            Text("Edit \(currentOptions.options[selectedButton])" as String)
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
            .SFProFont(style: .body, weight: .regular)
            
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
        Spacer()
    }
}
