//
//  OptionsView.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import SwiftUI
import AVFoundation
import AVKit
import CoreData

struct OptionsView: View {
    @State var showAddModal: Bool = false
    @State var showDeleteModal: Bool = false
    @State var showEditModal: Bool = false
    @State var viewBeingDisplayed: Bool = false
    @ObservedObject var currentOptions: CurrentOptions
    @ObservedObject var bleController: BLEController
    @ObservedObject var globals: GlobalVars
    var gridItemLayout = Array(repeating: GridItem(.flexible()), count: 3)
    @State var audioPlayer : AVAudioPlayer! //define audio player
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var synthesizer =  AVSpeechSynthesizer()
    @State var lastIndexSaid: Int = 0
    @State var numFlexes: Int = 0
    @State var changed: Bool = false
    @State var tapTimer: Timer?
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var parent: ButtonOption?
    @State var options: [ButtonOption]
    @State var currentCount: Int = 0
    @State var initial: Bool = true
    
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
                            clickSelectedButton()
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
                .onAppear {
                    currentOptions.startTimer(count: currentCount)
                }
                .onDisappear {
                    currentOptions.stopTimer()
                }

                Spacer()

                VStack {
                    Spacer()
                    LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 0) {
                        ForEach(0 ..< currentCount - (currentCount % 3), id: \.self) { index in
                            returnOption(index: index)
                        }
                    }
                    .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                    Spacer()
                    if (currentCount % 3 != 0) {
                        LazyHStack(spacing: 0) {
                            ForEach(currentCount - (currentCount % 3) ..< currentCount, id: \.self) { index in
                                returnOption(index: index)
                            }
                        }
                        .SFProFont(style: .largeTitle, weight: .regular, multiplier: GlobalVars_Unifier.multiplier_unifier)
                    }
                   
                }
                Spacer()
                
                HStack() {
                    Button(action: {
                        if (self.parent?.level != 0) {
                            self.parent = self.parent!.parent
                            currentOptions.currLevel -= 1
                            self.options = getOptions()
                            self.currentCount = self.options.count
                            currentOptions.stopTimer()
                            currentOptions.startTimer(count: self.currentCount)
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
                        self.audioPlayer.play() //play the sound
                        self.audioPlayer.play() //play the sound
                        
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
                            ModalAddView(showAddModal: self.$showAddModal, parent: $parent)
                                .environment(\.managedObjectContext, viewContext)
                                .environmentObject(self.currentOptions)
                                .environmentObject(self.globals)
                                .animation(.easeInOut))
                        .onDisappear {
                            options = getOptions()
                            currentCount = options.count
                        }
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
                            ModalEditView(showEditModal: self.$showEditModal, options: options)
                                .environment(\.managedObjectContext, viewContext)
                                .environmentObject(self.currentOptions)
                                .environmentObject(self.globals)
                                .animation(.easeInOut))
                        .onDisappear{
                            options = getOptions()
                            currentCount = options.count
                        }
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
                            ModalDeleteView(showDeleteModal: self.$showDeleteModal, parent: parent, options: options)
                                .environment(\.managedObjectContext, viewContext)
                                .environmentObject(self.currentOptions)
                                .environmentObject(self.globals)
                                .animation(.easeInOut))
                        .onDisappear{
                            options = getOptions()
                            currentCount = options.count
                        }
                }
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear(perform: {
            viewBeingDisplayed = true
            initializeOptions()
            // find sound path and construct audioPlayer
            let sound = Bundle.main.path(forResource: "zapsplat_hospital_tone", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//            print("----on appear options view---")
            
        })
        .onDisappear(perform: {
            viewBeingDisplayed = false
        })
        .onReceive(currentOptions.$selectedBtn, perform: {_ in
            print("on Receive gets: ",currentOptions.selectedBtn)
//            let options = getOptions()
            var selectedIdx = currentOptions.selectedBtn + 1
            if (options.count == 0) {
                return
            }
            if (selectedIdx >= options.count) {
                if(options.count != 0){
                    selectedIdx = selectedIdx % options.count
                    selectedIdx = 0
                }
                else{
                    selectedIdx = 0
                }
            }
            print("selected index we receive: ", selectedIdx)
            let actualSelectedBtn = options[selectedIdx]
            let utterance = AVSpeechUtterance(string: actualSelectedBtn.text)
            print("the text we decide to say: ", actualSelectedBtn.text)
            //self.synthesizer = AVSpeechSynthesizer()
//            if(GlobalVars_Unifier.text_unifier && !self.synthesizer.isSpeaking ){
//                print("and then we speak the text")
//                self.synthesizer.speak(utterance)
//                self.lastIndexSaid = currentOptions.selectedBtn
//            }
        })
        .onReceive(bleController.$selected, perform: {_ in
            if (self.viewBeingDisplayed == true &&
                options.count != 0 &&
                bleController.selected == true &&
                changed == false) {
                numFlexes += 1
                changed = true
                if tapTimer == nil {
                    tapTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { timer in
                        checkTaps()
                    }
                }
                else {
                    tapTimer?.invalidate()
                    if numFlexes > 2 {
                        tapTimer = nil
                        self.audioPlayer.play() //play the sound
                        self.audioPlayer.play() //play the sound
//                        print("help")
                    }
                    else {
                        tapTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { timer in
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
    
    func initializeOptions() {
        print("init")
        if !initial {
            return
        }
        initial = false
        let fetchRequest = NSFetchRequest<ButtonOption>(entityName: "ButtonOption")
        var entitiesCount = 0
        do {
            entitiesCount = try viewContext.count(for: fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }
        
        if entitiesCount != 0 {
            fetchRequest.predicate = NSPredicate(format: "level == %i", currentOptions.currLevel)
            do {
                try self.parent = viewContext.fetch(fetchRequest)[0]
                self.options = getOptions()
                self.currentCount = self.options.count
            } catch {
                self.parent = nil
                print("no parent")
            }
            return
        }
        
        let optionText = ["", "Responses", "Yes", "No", "Toys", "Juno", "Bumper Car", "Movies/Shows", "Frozen", "AlphaBlocks", "Classical", "Beethoven", "Mozart", "Mendelssohn", "Tchaikovsky", "Music", "Country", "Rock and Roll"]
        let optionImages = ["scribble.variable", "bubble.left.fill", "checkmark.circle.fill", "xmark.circle.fill", "gamecontroller.fill", "hare.fill", "car.fill", "play.rectangle.fill", "snow", "abc", "music.quarternote.3", "", "", "", "", "music.note", "", "music.mic"]
        let optionsIsFolder = [true, true, false, false, true, false, false, true, false, false, true, false, false, false, false, true, false, false]
        let optionsLevel = [0, 1, 2, 2, 1, 2, 2, 1, 2, 2, 2, 3, 3, 3, 3, 1, 2, 2]
        let optionsSystem = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
        var buttonOptions: [ButtonOption] = []
        var image: UIImage
        
        for i in 0..<optionText.count {
            let newOption = ButtonOption(context: viewContext)
            print(optionText[i])
            newOption.text = optionText[i]
            let config = UIImage.SymbolConfiguration(pointSize: 24)
            image = UIImage(systemName: optionImages[i]) ?? UIImage()
                .withRenderingMode(.alwaysTemplate)
                .withConfiguration(config)
                .withTintColor(.white)
            newOption.image = image.pngData()
            newOption.isFolder = optionsIsFolder[i]
            newOption.level = optionsLevel[i]
            newOption.system = optionsSystem[i]
            buttonOptions.append(newOption)
        }
        buttonOptions[0].addToChildren([buttonOptions[1], buttonOptions[4], buttonOptions[7], buttonOptions[15]])
        buttonOptions[1].addToChildren([buttonOptions[2], buttonOptions[3]])
        buttonOptions[4].addToChildren([buttonOptions[5], buttonOptions[6]])
        buttonOptions[7].addToChildren([buttonOptions[8], buttonOptions[9]])
        buttonOptions[10].addToChildren([buttonOptions[11], buttonOptions[12], buttonOptions[13], buttonOptions[14]])
        buttonOptions[15].addToChildren([buttonOptions[10], buttonOptions[16], buttonOptions[17]])
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        self.parent = buttonOptions[0]
        self.options = getOptions()
        currentCount = self.options.count
    }
    
    func getOptions() -> [ButtonOption] {
        let request = NSFetchRequest<ButtonOption>(entityName: "ButtonOption")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ButtonOption.text, ascending: true)]
        if parent != nil {
            request.predicate = NSPredicate(format: "level == %i AND parent == %@", currentOptions.currLevel + 1, parent! as ButtonOption)
        }
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func clickSelectedButton() {
        if (options.count != 0) {
            if (currentOptions.timer == nil) {
                return
            }
            currentOptions.stopTimer()
            currentOptions.timer = nil
            let selectedBtn = options[currentOptions.selectedBtn]
            selectedBtn.selected = true
            currentOptions.confirmSelected = true
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
                selectedBtn.selected = false
                currentOptions.confirmSelected = false
                if (selectedBtn.isFolder) {
                    // folder
                    self.parent = options[currentOptions.selectedBtn]
                    currentOptions.currLevel = self.parent!.level
                    options = getOptions()
                    self.currentCount = options.count
                }
                else {
                    // not folder
                    print(selectedBtn.text)
                }
                print("pre self timer we have :", currentOptions.selectedBtn)
                
                if (selectedBtn.isFolder) {
                    
                    currentOptions.selectedBtn = -1
                    print("moved------- selectedBtn si: ", currentOptions.selectedBtn)
                    currentOptions.selectedBtn = 0
//                    currentOptions.startTimer(count: -1)
                }
               
                currentOptions.startTimer(count: self.currentCount)
            }
        }
    }
    
    func checkTaps() {
        if numFlexes == 1 {
            clickSelectedButton()
        }
        else if numFlexes == 2 {
            if (parent?.level != 0) {
                self.parent = self.parent!.parent
                currentOptions.currLevel -= 1
                self.options = getOptions()
                self.currentCount = self.options.count
                currentOptions.stopTimer()
                currentOptions.startTimer(count: self.currentCount)
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
        if (selectedIdx >= options.count) {
            selectedIdx = options.count - 1
        }
        let selectedBtn = options[index]
        let isSelected = selectedBtn.selected
        var color: Color = (selectedIdx == index) ? Color.blue : Color.black
        color = isSelected ? Color.green : color
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var cornerRadius: CGFloat = 50
        // read out text of selected button
        var wouldRepeat: Bool = (GlobalVars_Unifier.last_text_said == options[index].text && !isSelected)
        
        
        print("last index said: ", GlobalVars_Unifier.last_index)
        if(selectedIdx == index && GlobalVars_Unifier.text_unifier && !self.synthesizer.isSpeaking && !wouldRepeat){

            let utterance = AVSpeechUtterance(string: selectedBtn.text)
            self.synthesizer = AVSpeechSynthesizer()
            self.synthesizer.speak(utterance)
          //  self.lastIndexSaid = index
            GlobalVars_Unifier.last_index = selectedIdx
            GlobalVars_Unifier.last_text_said = selectedBtn.text
            
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
                        let data = options[index].image ?? nil
                        let config = UIImage.SymbolConfiguration(pointSize: 24)
                        if data != nil {
                            if options[index].system {
                                Image(uiImage: UIImage(data: data!)!
                                        .withRenderingMode(.alwaysTemplate)
                                        .withConfiguration(config)
                                        .withTintColor(.white))
                                    .resizable()
                                    .scaledToFill()
                            }
                            else {
                                Image(uiImage: UIImage(data: data!)!)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        else {
                            Image(uiImage: UIImage())
                                .resizable()
                                .scaledToFill()
                        }
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

//struct OptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OptionsView(currentOptions: CurrentOptions(), bleController: BLEController(), globals: GlobalVars())
//            .environmentObject(GlobalVars())
//    }
//}
