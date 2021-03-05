//
//  ModalEditView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

struct ModalEditView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @Binding var showEditModal: Bool
    @State private var btnText: String = ""
    
    var body: some View {
        VStack {
            Text("Add Button")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            HStack {
                Text("Text:")
                    .SFProFont(style: .callout, weight: .regular)
                TextField("Enter Button Text", text: $btnText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
            }
            HStack {
                Button(action: {
                    print("close form")
                    withAnimation {
                        self.showEditModal.toggle()
                    }
                }, label: {
                    Text("Close")
                })
                Button(action: {
                    print("add button from form")
                    currentOptions.addOption(text: btnText)
                    withAnimation {
                        self.showEditModal.toggle()
                    }
                }, label: {
                    Text("Add Button")
                })
            }
        }
        Spacer()
    }
}
