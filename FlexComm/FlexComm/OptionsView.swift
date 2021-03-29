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
                .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier / 2.95) //made it not as extreme for text, but still changing
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
                            returnOption(index: index)
                        }
                    }
                    .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                    Spacer()
                    if (optionCount % 3 != 0) {
                        LazyHStack(spacing: 0) {
                            ForEach(optionCount - (optionCount % 3) ..< optionCount, id: \.self) { index in
                                returnOption(index: index)
                            }
                        }
                        .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                    }
                   
                }
                Spacer()
                
                HStack() {
                    Button(action: {
                        currentOptions.prevOptions()
                    }, label: {
                        HStack() {
                            Text("BACK")
                            Image(systemName: "arrow.uturn.backward")
                        }
                        .foregroundColor(.white)
                        .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                        .padding(10)
                        .background(Color.blue)
                    })
                    
                    Spacer()
                    
                    Button(action: { // help button
                        print("HELP")
                    }, label:  {
                        HStack() {
                            Text("HELP")
                            Image(systemName: "phone.fill")
                        }
                        .foregroundColor(.white)
                        .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                        .padding(10)
                        .background(Color.red)
                    })
                }
                .padding(10)
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
    
    func returnOption(index: Int) -> some View {
        var selectedIdx = currentOptions.selectedBtn
        if (selectedIdx >= currentOptions.options.count) {
            selectedIdx = currentOptions.options.count - 1
        }
        let isSelected = currentOptions.options[index].selected
        var color: Color = (selectedIdx == index) ? Color.blue : Color.black
        color = isSelected ? Color.green : color
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var cornerRadius: CGFloat = 50
        if (currentOptions.options[index].isFolder) {
            cornerRadius = 20
            xOffset = -52
            yOffset = -30
        }
        return ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
                .frame(width: 150, height: 240, alignment: .bottomLeading)
                .offset(x: xOffset, y: yOffset)
            Button(action: {}) {
                VStack(spacing: 20) {
                    Text(currentOptions.options[index].text)
                    Group {
                        Image(uiImage: currentOptions.options[index].image)
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 100, height: 100, alignment: .center)
                }
            }
            .buttonStyle(CustomButton())
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(color))
            .padding(20)
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
            .environmentObject(GlobalVars())
    }
}
