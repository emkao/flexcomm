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
    @StateObject var globals = GlobalVars()
    @State var saved: [Int]
    
    var body: some View {
        Text("Edit Options")
            .font(.custom("SFProText-Thin", size: 50))
            .padding(20)
            .onAppear(perform: {
                saved = currentOptions.options
            })
        List(currentOptions.options.indices, id: \.self) { index in
            HStack {
                Button(currentOptions.allOptions[currentOptions.options[index]]!.text) {
                    withAnimation{
                        selectedButton = index
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
                currentOptions.options = saved
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
            ButtonEditView(globals: globals, selectedButton: $selectedButton, editButton: $editButton)
                .environmentObject(self.currentOptions)
                .transition(.moveAndFade)
        }
    }
}

