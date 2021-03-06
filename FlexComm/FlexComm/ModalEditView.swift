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
    
    var body: some View {
        HStack {
            Button(action: {
                print("close form")
                self.showEditModal.toggle()
            }, label: {
                Text("Close")
            })
            .padding(30)
            
            Spacer()
            
            Button(action: {
                print("add button from form")
//                currentOptions.addOption(text: btnText)
                self.showEditModal.toggle()
            }, label: {
                Text("Add")
            })
            .padding(30)
        }
    }
}
