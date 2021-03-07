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
    @State var selections: [String] = []
    
    var body: some View {
        VStack {
            Text("Delete Button(s)")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            
            List {
                ForEach(self.currentOptions.options, id: \.self) { item in
                    MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                        if self.selections.contains(item) {
                            self.selections.removeAll(where: { $0 == item })
                        }
                        else {
                            self.selections.append(item)
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
                    currentOptions.deleteOption(selections: self.selections)
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
