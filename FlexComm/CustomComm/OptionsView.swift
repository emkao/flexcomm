//
//  OptionsView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI
import AVFoundation

struct OptionsView: View {
    @State var showAddModal: Bool = false
    @State var showDeleteModal: Bool = false
    @State var showEditModal: Bool = false
    @State var viewBeingDisplayed: Bool = false
    @ObservedObject var currentOptions: CurrentOptions
    @ObservedObject var bleController: BLEController
//    @StateObject var globals = GlobalVars()
    @ObservedObject var globals: GlobalVars
    var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    var player : AVAudioPlayer! = nil
//    @State var helpSoundEffect = AVAudioPlayer()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var numFlexes: Int = 0
    @State var changed: Bool = false
    @State var tapTimer: Timer?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { // back button
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "house")
                    })
                    Spacer()
                    Group {
                        Button(action: {
                            if (currentOptions.options.count != 0) {
                                currentOptions.clickSelectedBtn()
                            }
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
                        destination: SettingsView(bleController: bleController),
                        label: {
                            Image(systemName: "gearshape")
                        })
                        .buttonStyle(PlainButtonStyle())
                        .navigationBarHidden(false)
                }
                .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier / 1.18) //made it not as extreme for text, but still changing
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
                        if (currentOptions.parent != 0) {
                            currentOptions.prevOptions()
                        }
                        else {
                            presentationMode.wrappedValue.dismiss()
                        }
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
//                        print(self._helpSoundEffect)
//                        let path = Bundle.main.path(forResource: "zapsplat_hospital_tone", ofType:"mp3")!
//                        let url = URL(fileURLWithPath: path)
//
//                        do {
//                            helpSoundEffect = try AVAudioPlayer(contentsOf: url)
//                            helpSoundEffect.play()
//                            print("works")
//                        } catch {
//                            // couldn't load file :(
//                            print("does not work")
//                        }
                        
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
        .onAppear(perform: {
            viewBeingDisplayed = true
        })
        .onDisappear(perform: {
            viewBeingDisplayed = false
        })
        .onReceive(bleController.$selected, perform: {_ in
            if (self.viewBeingDisplayed == true &&
                currentOptions.options.count != 0 &&
                bleController.selected == true &&
                changed == false) {
                numFlexes += 1
                changed = true
                if tapTimer == nil {
                    tapTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                        checkTaps()
                    }
                }
                else {
                    tapTimer?.invalidate()
                    if numFlexes > 2 {
                        tapTimer = nil
                        print("help")
                    }
                    else {
                        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                            checkTaps()
                        }
                    }
                }
            }
            else {
                changed = false
                if tapTimer == nil {
                    numFlexes = 0
                }
            }
        })
    }
    
    func checkTaps() {
        if numFlexes == 1 {
            currentOptions.clickSelectedBtn()
        }
        else if numFlexes == 2 {
            if (currentOptions.parent != 0) {
                currentOptions.prevOptions()
            }
            else {
                presentationMode.wrappedValue.dismiss()
            }
        }
        else if numFlexes > 2 {
            print("help")
        }
        tapTimer?.invalidate()
        tapTimer = nil
    }
    
    func returnOption(index: Int) -> some View {
        var selectedIdx = currentOptions.selectedBtn
        if (selectedIdx >= currentOptions.options.count) {
            selectedIdx = currentOptions.options.count - 1
        }
        let allOptions = currentOptions.allOptions
        let selectedBtn = allOptions[currentOptions.options[index]]!
        let isSelected = selectedBtn.selected
        var color: Color = (selectedIdx == index) ? Color.blue : Color.black
        color = isSelected ? Color.green : color
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var cornerRadius: CGFloat = 50
        // read out text of selected button
        if(selectedIdx == index && GlobalVars_Unifier.text_unifier){
            let utterance = AVSpeechUtterance(string: selectedBtn.text)
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
       
        if (selectedBtn.isFolder) {
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
                    Text(selectedBtn.text)
                    Group {
                        Image(uiImage: selectedBtn.image.getImage())
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
        OptionsView(currentOptions: CurrentOptions(), bleController: BLEController(), globals: GlobalVars())
            .environmentObject(GlobalVars())
    }
}
