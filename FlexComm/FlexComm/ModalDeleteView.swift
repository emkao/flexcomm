//
//  ModalDeleteView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

struct ModalDeleteView: View {
    @EnvironmentObject var currentOptions: CurrentOptions
    @Binding var showDeleteModal: Bool
    @State var selections: [Int] = []
    
    var body: some View {
        VStack {
            Text("Delete Button(s)")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            
            List {
                ForEach(self.currentOptions.options.indices, id: \.self) { index in
                    MultipleSelectionRow(title: self.currentOptions.options[index].text, isSelected: self.selections.contains(index)) {
                        if self.selections.contains(index) {
                            self.selections.removeAll(where: { $0 == index })
                        }
                        else {
                            self.selections.append(index)
                        }
                    }
                }
            }
            
            HStack {
                Button(action: {
                    self.showDeleteModal.toggle()
                }, label: {
                    Text("Cancel")
                })
                .padding(30)
                
                Spacer()
                
                Button(action: {
                    currentOptions.deleteOption(removeIndices: self.selections)
                    self.showDeleteModal.toggle()
                }, label: {
                    Text("Delete")
                })
                .padding(30)
            }
        }
        Spacer()
    }
}

struct MultipleSelectionRow: View {
    var title: String
        var isSelected: Bool
        var action: () -> Void

        var body: some View {
            Button(action: self.action) {
                HStack {
                    Text(self.title)
                    if self.isSelected {
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
}
