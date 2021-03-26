//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation

class CurrentOptions: ObservableObject, Codable {
    enum CodingOptions: CodingKey {
        case options
    }
    
    @Published var parent: ButtonOption
    @Published var options = [ButtonOption]() //{
//        didSet {
//            save()
//        }
    //}
    @Published var selectedBtn: Int = 0
    @Published var confirmSelected: Bool = false
    var timer: Timer?
    
    init() {
//        if let options = UserDefaults.standard.data(forKey: "saved_options") {
//            let decoder = PropertyListDecoder()
//            if let decoded = try? decoder.decode([ButtonOption].self, from: options) {
//                self.options = decoded
//                return
//            }
//            self.parent = ButtonOption(text: "root")
//            self.parent.addChildren(children: [ButtonOption(text: "Yes"), ButtonOption(text: "No")])
//            self.options = self.parent.children
//        }
        self.parent = ButtonOption(text: "root", isFolder: true)
        
        let responses = ButtonOption(text: "Responses", isFolder: true)
        responses.addChildren(children: [ButtonOption(text: "Yes", isFolder: false), ButtonOption(text: "No", isFolder: false)])
        
        let toys = ButtonOption(text: "Toys", isFolder: true)
        toys.addChildren(children: [ButtonOption(text: "Juno", isFolder: false), ButtonOption(text: "Bumper Car", isFolder: false)])
        
        let movies = ButtonOption(text: "Movies/Shows", isFolder: true)
        movies.addChildren(children: [ButtonOption(text: "Frozen", isFolder: false), ButtonOption(text: "AlphaBlocks", isFolder: false)])
        
        let classical = ButtonOption(text: "Classical", isFolder: true)
        classical.addChildren(children: [ButtonOption(text: "Beethoven", isFolder: false), ButtonOption(text: "Mozart", isFolder: false), ButtonOption(text: "Mendelssohn", isFolder: false), ButtonOption(text: "Tchaikovsky", isFolder: false)])
        
        let music = ButtonOption(text: "Music", isFolder: true)
        music.addChildren(children: [classical, ButtonOption(text: "Country", isFolder: false), ButtonOption(text: "Rock and Roll", isFolder: false)])
        
        self.parent.addChildren(children: [responses, toys, movies, music])
        self.options = self.parent.children
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingOptions.self)
        try container.encode(self.options, forKey: .options)
    }
    
    required init(from decoder: Decoder) throws {
//        let options = try decoder.container(keyedBy: CodingOptions.self)
//
//        if let decoded = try? options.decode([ButtonOption].self, forKey: .options) {
//            self.options = decoded
//            return
//        }
        
        self.parent = ButtonOption(text: "root", isFolder: true)
        
        let responses = ButtonOption(text: "Responses", isFolder: true)
        responses.addChildren(children: [ButtonOption(text: "Yes", isFolder: false), ButtonOption(text: "No", isFolder: false)])
        
        let toys = ButtonOption(text: "Toys", isFolder: true)
        toys.addChildren(children: [ButtonOption(text: "Juno", isFolder: false), ButtonOption(text: "Bumper Car", isFolder: false)])
        
        let movies = ButtonOption(text: "Movies/Shows", isFolder: true)
        movies.addChildren(children: [ButtonOption(text: "Frozen", isFolder: false), ButtonOption(text: "AlphaBlocks", isFolder: false)])
        
        let classical = ButtonOption(text: "Classical", isFolder: true)
        classical.addChildren(children: [ButtonOption(text: "Beethoven", isFolder: false), ButtonOption(text: "Mozart", isFolder: false), ButtonOption(text: "Mendelssohn", isFolder: false), ButtonOption(text: "Tchaikovsky", isFolder: false)])
        
        let music = ButtonOption(text: "Music", isFolder: true)
        music.addChildren(children: [classical, ButtonOption(text: "Country", isFolder: false), ButtonOption(text: "Rock and Roll", isFolder: false)])
        
        self.parent.addChildren(children: [responses, toys, movies, music])
        self.options = self.parent.children
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {_ in
            if self.options.count != 0 {
                self.selectedBtn = (self.selectedBtn + 1) % self.options.count
            }
            else {
                self.selectedBtn = 0
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    func addOption(text: String, isFolder: Bool) {
        if (self.options.count < 6) {
            let newOption = ButtonOption(text: text, isFolder: isFolder)
            for child in self.parent.children {
                child.addSibling(sibling: newOption)
                newOption.addSibling(sibling: child)
            }
            newOption.addSibling(sibling: newOption)
            self.parent.addChild(child: newOption)
            self.options = self.parent.children
        }
    }
    
    func deleteOption(removeIndices: [Int]) {
        self.parent.removeChildren(removeIndices: removeIndices)
        self.options = self.parent.children
    }
    
    func editOption(index: Int, text: String, isFolder: Bool) {
        let btn = self.parent.children[index]
        btn.text = text
        btn.isFolder = isFolder
        if (!isFolder) {
            btn.children = []
        }
        self.options = self.parent.children
    }
    
    func save() {
        if let encoded = try? PropertyListEncoder().encode(options) {
            UserDefaults.standard.set(encoded, forKey: "saved_options")
        }
    }
    
    func prevOptions() {
        if (self.parent.text != "root") {
            self.options = self.parent.siblings
            self.parent = self.options[0].parent!
        }
    }
    
    func clickSelectedBtn() {
        self.stopTimer()
        self.options[self.selectedBtn].selected = true
        self.confirmSelected = true
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
            self.options[self.selectedBtn].selected = false
            if (self.options[self.selectedBtn].isFolder) {
                // folder
                self.parent = self.options[self.selectedBtn]
                self.options = self.parent.children
                self.selectedBtn = 0
            }
            else {
                // not folder
                print(self.options[self.selectedBtn].text)
            }
            self.confirmSelected = false
            self.startTimer()
        }
    }
}
