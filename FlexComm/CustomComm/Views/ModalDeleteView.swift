//
//  ModalDeleteView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

struct ModalDeleteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var currentOptions: CurrentOptions
    @Binding var showDeleteModal: Bool
    @State var selections: IndexSet = IndexSet()
    var parent: ButtonOption?
    var options: [ButtonOption]
    
    var body: some View {
        VStack {
            Text("Delete Option(s)")
                .font(.custom("SFProText-Thin", size: 50))
                .padding(20)
            
            List {
                ForEach(options.indices, id: \.self) { index in
                    MultipleSelectionRow(title: options[index].text, isSelected: self.selections.contains(index)) {
                        if self.selections.contains(index) {
                            self.selections.remove(index)
                        }
                        else {
                            self.selections.insert(index)
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
                    parent?.removeFromChildren(at: NSIndexSet(indexSet: self.selections))
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    currentOptions.stopTimer()
                    currentOptions.startTimer(count: options.count)
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
