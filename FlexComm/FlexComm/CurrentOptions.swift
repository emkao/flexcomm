//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation
import UIKit

class CurrentOptions: ObservableObject { // Codable
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
        initializeOptions()
        self.options = self.parent.children
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingOptions.self)
//        try container.encode(self.options, forKey: .options)
//    }
    
    required init(from decoder: Decoder) throws {
//        let options = try decoder.container(keyedBy: CodingOptions.self)
//
//        if let decoded = try? options.decode([ButtonOption].self, forKey: .options) {
//            self.options = decoded
//            return
//        }
        
        self.parent = ButtonOption(text: "root", isFolder: true)
        initializeOptions()
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
    
    func initializeOptions() {
        let responses = ButtonOption(text: "Responses", image: "bubble.left.fill", isFolder: true)
        responses.addChildren(children: [ButtonOption(text: "Yes", image: "checkmark.circle.fill", isFolder: false), ButtonOption(text: "No", image: "xmark.circle.fill", isFolder: false)])
        
        let toys = ButtonOption(text: "Toys", image: "gamecontroller.fill", isFolder: true)
        toys.addChildren(children: [ButtonOption(text: "Juno", image: "hare.fill", isFolder: false), ButtonOption(text: "Bumper Car", image: "car.fill", isFolder: false)])
        
        let movies = ButtonOption(text: "Movies/Shows", image: "play.rectangle.fill", isFolder: true)
        movies.addChildren(children: [ButtonOption(text: "Frozen", image: "snow", isFolder: false), ButtonOption(text: "AlphaBlocks", image: "abc", isFolder: false)])
        
        let classical = ButtonOption(text: "Classical", image: "music.quarternote.3", isFolder: true)
        classical.addChildren(children: [ButtonOption(text: "Beethoven", isFolder: false), ButtonOption(text: "Mozart", isFolder: false), ButtonOption(text: "Mendelssohn", isFolder: false), ButtonOption(text: "Tchaikovsky", isFolder: false)])
        
        let music = ButtonOption(text: "Music", image: "music.note", isFolder: true)
        music.addChildren(children: [classical, ButtonOption(text: "Country", isFolder: false), ButtonOption(text: "Rock and Roll", image: "music.mic", isFolder: false)])
        
        self.parent.addChildren(children: [responses, toys, movies, music])
    }
    
    func addOption(text: String, image: UIImage, isFolder: Bool) {
        if (self.options.count < 6) {
            let newOption = ButtonOption(text: text, image: image, isFolder: isFolder)
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
    
    func editOption(index: Int, text: String, image: UIImage, isFolder: Bool) {
        let btn = self.parent.children[index]
        btn.text = text
        btn.image = image
        btn.isFolder = isFolder
        if (!isFolder) {
            btn.children = []
        }
        self.options = self.parent.children
    }
    
//    func save() {
//        if let encoded = try? PropertyListEncoder().encode(options) {
//            UserDefaults.standard.set(encoded, forKey: "saved_options")
//        }
//    }
    
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
