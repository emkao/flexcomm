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
    //@EnvironmentObject var globals: GlobalVars
    @StateObject var globals = GlobalVars()
    private var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { // back button
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Menu")
                    })
                    Spacer()
                    Group {
                        Button(action: {
                            currentOptions.prevOptions()
                        }, label: {
                            Text("Prev Options")
                        })
                        Spacer()
                        Button(action: {
                            currentOptions.clickSelectedBtn()
                        }, label: {
                            Text("Moved Flex Sensor")
                        })
                        Spacer()
                    }
                    Group {
                        Button(action: { // add button
                            self.showAddModal.toggle()
                        }, label:  {
                            Text("Add")
                        })
                        Spacer()
                        Button(action: { // add button
                            self.showEditModal.toggle()
                        }, label:  {
                            Text("Edit")
                        })
                        Spacer()
                        Button(action: { // delete button
                            self.showDeleteModal.toggle()
                        }, label:  {
                            Text("Delete")
                        })
                        Spacer()
                    }
                    NavigationLink(
                        destination: SettingsView(),
                        label: {
                            Text("Settings")
                        })
                        .buttonStyle(PlainButtonStyle())
                }
                .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier / 1.75) //made it not as extreme for text, but still changing
                .foregroundColor(.black)
                .padding(10.0)
                .onAppear{
                    currentOptions.startTimer()
                }
                .onDisappear{
                    currentOptions.stopTimer()
                }

                Spacer()
                let optionCount = currentOptions.options.count
                VStack {
                    Spacer()
                    LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 0) {
                        ForEach(0 ..< optionCount - (optionCount % 3), id: \.self) { index in
                            let color: Color = (currentOptions.selectedBtn == index) ? Color.blue : Color.black
                            Button(currentOptions.options[index % optionCount].text) {}
                                .buttonStyle(CustomButton())
                                .background(RoundedRectangle(cornerRadius: 50).fill(color))
                                .padding(20)
                        }
                    }
                    .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                    Spacer()
                    if (optionCount % 3 != 0) {
                        LazyHStack(spacing: 0) {
                            ForEach(optionCount - (optionCount % 3) ..< optionCount, id: \.self) { index in
                                let color: Color = (currentOptions.selectedBtn == index) ? Color.blue : Color.black
                                Button(currentOptions.options[index % optionCount].text) {}
                                    .buttonStyle(CustomButton())
                                    .background(RoundedRectangle(cornerRadius: 50).fill(color))
                                    .padding(20)
                            }
                        }
                        .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                    }
                   
                }
                Spacer()
            }
            
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
            
            if showEditModal {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(
                            ModalEditView(showEditModal: self.$showEditModal, saved: self.currentOptions.options)
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
            .environmentObject(GlobalVars())
    }
}
