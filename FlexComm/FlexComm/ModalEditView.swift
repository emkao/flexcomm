//
//  ModalEditView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct ModalEditView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @Binding var showEditModal: Bool
    @State private var editButton: Bool = false
    @State private var selectedButton: Int = -1
    
    var body: some View {
        Text("Edit Buttons")
            .font(.custom("SFProText-Thin", size: 50))
            .padding(20)
        List(currentOptions.options.indices, id: \.self) { index in
            HStack {
                Button(currentOptions.options[index].text) {
                    withAnimation{
                        print(selectedButton)
                        print(index)
                        selectedButton = index
                        print(selectedButton)
                        editButton.toggle()
                    }
                }
                Spacer()
                Image(systemName: "pencil")
            }
        }
        HStack {
            Button(action: {
                self.showEditModal.toggle()
            }, label: {
                Text("Cancel")
            })
            .padding(30)
            
            Spacer()
            
            Button(action: {
                self.showEditModal.toggle()
            }, label: {
                Text("Done")
            })
            .padding(30)
        }
        
        .sheet(isPresented: $editButton) {
            ButtonEditView(selectedButton: $selectedButton, editButton: $editButton)
                .environmentObject(self.currentOptions)
                .transition(.moveAndFade)
        }
    }
}
