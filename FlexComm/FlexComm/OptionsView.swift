//
//  OptionsView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI

struct OptionsView: View {
    @State var showAddModal: Bool = false
    @State var showDeleteModal: Bool = false
    @State var showEditModal: Bool = false
    @ObservedObject var currentOptions = CurrentOptions()
    private var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { // back button
                        print("Go back")
                    }) {
                        Text("Menu")
                    }
                    Spacer()
                    Button(action: { // add button
                        print("Add button")
                        self.showAddModal.toggle()
                    }) {
                        Text("Add")
                    }
                    Spacer()
                    Button(action: { // add button
                        print("Edit button")
                        self.showEditModal.toggle()
                    }) {
                        Text("Edit")
                    }
                    Spacer()
                    Button(action: { // delete button
                        print("Delete button")
                        self.showDeleteModal.toggle()
                    }) {
                        Text("Delete")
                    }
                    Spacer()
                    Button(action: { // settings button
                        print("Go to settings")
                    }) {
                        Text("Settings")
                    }
                }
                .foregroundColor(.black)
                .padding(10.0)

                Spacer()
                let optionCount = currentOptions.options.count
                VStack {
                    Spacer()
                    LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 0) {
                        ForEach(0 ..< optionCount - (optionCount % 3), id: \.self) {
                            Button(currentOptions.options[$0 % optionCount]) {}
                                .buttonStyle(CustomButton())
                        }
                    }
                    if (optionCount % 3 != 0) {
                        Spacer()
                        LazyHStack(spacing: 0) {
                            ForEach(optionCount - (optionCount % 3) ..< optionCount, id: \.self) {
                                Button(currentOptions.options[$0 % optionCount]) {}
                                    .buttonStyle(CustomButton())
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .SFProFont(style: .largeTitle, weight: .regular)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
            if showAddModal {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(
                            ModalAddView(showAddModal: self.$showAddModal)
                                .environmentObject(self.currentOptions)).animation(.easeInOut)
                }
                .transition(.move(edge: .bottom))
            }
            
            if showDeleteModal {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(
                            ModalDeleteView(showDeleteModal: self.$showDeleteModal)
                                .environmentObject(self.currentOptions)).animation(.easeInOut)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
