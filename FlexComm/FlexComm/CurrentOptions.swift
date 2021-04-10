//
//  CurrentOptions.swift
//  FlexComm
//
//  Created by emily kao on 3/4/21.
//

import Foundation
import SwiftUI
import UIKit

class CurrentOptions: ObservableObject, Codable {
    private enum CodingOptions: CodingKey {
        case parent, options, allOptions
    }
    
    @Published var parent: Int {
        didSet {
            save_parent()
        }
    }
    @Published var options = [Int]() {
        didSet {
            save_options()
        }
    }
    @Published var selectedBtn: Int = 0
    @Published var confirmSelected: Bool = false
    var timer: Timer?
    var allOptions: [Int: ButtonOption] = [:] {
        didSet {
            save_all_options()
        }
    }
    
    init() {
//        let property_decoder = PropertyListDecoder()
//        let json_decoder = JSONDecoder()
//        if let ops = UserDefaults.standard.data(forKey: "saved_options") {
//            if let decoded_options = try? property_decoder.decode([Int].self, from: ops) {
//                self.options = decoded_options
//                if let prt = UserDefaults.standard.data(forKey: "saved_parent") {
//                    if let decoded_parent = try? json_decoder.decode(Int.self, from: prt) {
//                        self.parent = decoded_parent
//                        if let all = UserDefaults.standard.data(forKey: "saved_all") {
//                            if let decoded_all = try? property_decoder.decode([Int:ButtonOption].self, from: all) {
//                                self.allOptions = decoded_all
//                                return
//                            }
//                        }
//                    }
//                }
//            }
//        }
        let property_decoder = PropertyListDecoder()
        if let all = UserDefaults.standard.data(forKey: "saved_all") {
            if let decoded_all = try? property_decoder.decode([Int:ButtonOption].self, from: all) {
                self.allOptions = decoded_all
                self.parent = 0
                self.options = self.allOptions[0]!.children
                return
            }
        }
        
        self.parent = 0
        allOptions[self.parent] = ButtonOption(text: "root", isFolder: true, index: self.parent)
        initializeOptions()
        self.options = allOptions[0]!.children
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingOptions.self)
//        try container.encode(self.parent, forKey: .parent)
//        try container.encode(self.options, forKey: .options)
        try container.encode(self.allOptions, forKey: .allOptions)
    }
    
    required init(from decoder: Decoder) throws {
//        let ops = try decoder.container(keyedBy: CodingOptions.self)
//        if let decoded_parent = try? ops.decode(Int.self, forKey: .parent) {
//            self.parent = decoded_parent
//            if let decoded_all = try? ops.decode([Int:ButtonOption].self, forKey: .allOptions) {
//                self.allOptions = decoded_all
//                if let decoded_options = try? ops.decode([Int].self, forKey: .options) {
//                    self.options = decoded_options
//                    return
//                }
//            }
//        }
        let ops = try decoder.container(keyedBy: CodingOptions.self)
        if let decoded_all = try? ops.decode([Int:ButtonOption].self, forKey: .allOptions) {
            self.allOptions = decoded_all
            self.parent = 0
            self.options = self.allOptions[0]!.children
            return
        }
        
        self.parent = 0
        allOptions[self.parent] = ButtonOption(text: "root", isFolder: true, index: self.parent)
        initializeOptions()
        self.options = allOptions[0]!.children
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
        allOptions[1] = ButtonOption(text: "Responses", image: "bubble.left.fill", isFolder: true, index: 1)
        allOptions[2] = ButtonOption(text: "Yes", image: "checkmark.circle.fill", isFolder: false, index: 2)
        allOptions[3] = ButtonOption(text: "No", image: "xmark.circle.fill", isFolder: false, index: 3)
        allOptions[1]!.addChildren(allOptions: allOptions, children: [2, 3])
        
        allOptions[4] = ButtonOption(text: "Toys", image: "gamecontroller.fill", isFolder: true, index: 4)
        allOptions[5] = ButtonOption(text: "Juno", image: "hare.fill", isFolder: false, index: 5)
        allOptions[6] = ButtonOption(text: "Bumper Car", image: "car.fill", isFolder: false, index: 6)
        allOptions[4]!.addChildren(allOptions: allOptions, children: [5, 6])
        
        allOptions[7] = ButtonOption(text: "Movies/Shows", image: "play.rectangle.fill", isFolder: true, index: 7)
        allOptions[8] = ButtonOption(text: "Frozen", image: "snow", isFolder: false, index: 8)
        allOptions[9] = ButtonOption(text: "AlphaBlocks", image: "abc", isFolder: false, index: 9)
        allOptions[7]!.addChildren(allOptions: allOptions, children: [8, 9])
        
        allOptions[10] = ButtonOption(text: "Classical", image: "music.quarternote.3", isFolder: true, index: 10)
        allOptions[11] = ButtonOption(text: "Beethoven", isFolder: false, index: 11)
        allOptions[12] = ButtonOption(text: "Mozart", isFolder: false, index: 12)
        allOptions[13] = ButtonOption(text: "Mendelssohn", isFolder: false, index: 13)
        allOptions[14] = ButtonOption(text: "Tchaikovsky", isFolder: false, index: 14)
        allOptions[10]!.addChildren(allOptions: allOptions, children: [11, 12, 13, 14])
        
        allOptions[15] = ButtonOption(text: "Music", image: "music.note", isFolder: true, index: 15)
        allOptions[16] = ButtonOption(text: "Country", isFolder: false, index: 16)
        allOptions[17] = ButtonOption(text: "Rock and Roll", image: "music.mic", isFolder: false, index: 17)
        allOptions[15]?.addChildren(allOptions: allOptions, children: [10, 16, 17])
        
        allOptions[0]!.addChildren(allOptions: allOptions, children: [1, 4, 7, 15])
    }
    
    func addOption(text: String, image: UIImage, isFolder: Bool) {
        if (self.options.count < 6) {
            let newOption = allOptions.count
            allOptions[newOption] = ButtonOption(text: text, image: image, isFolder: isFolder, index: newOption)
            for child in allOptions[self.parent]!.children {
                allOptions[child]!.addSibling(sibling: newOption)
                allOptions[newOption]!.addSibling(sibling: child)
            }
            allOptions[newOption]!.addSibling(sibling: newOption)
            allOptions[self.parent]!.addChild(allOptions: allOptions, child: newOption)
            self.options = allOptions[self.parent]!.children
            save_all_options()
            save_options()
        }
    }
    
    func deleteOption(removeIndices: [Int]) {
        allOptions[self.parent]!.removeChildren(allOptions: allOptions, removeIndices: removeIndices)
        self.options = allOptions[self.parent]!.children
        save_all_options()
        save_options()
    }
    
    func editOption(index: Int, text: String, image: UIImage, isFolder: Bool) {
        let btn = allOptions[allOptions[self.parent]!.children[index]]!
        btn.text = text
        btn.image = CustomImage(withImage: image, withSystem: false)
        btn.isFolder = isFolder
        if (!isFolder) {
            btn.children = []
        }
        self.options = allOptions[self.parent]!.children
        save_all_options()
        save_options()
    }
    
    func save_options() {
        if let encoded_options = try? PropertyListEncoder().encode(self.options) {
            UserDefaults.standard.set(encoded_options, forKey: "saved_options")
        }
    }
    
    func save_parent() {
        if let encoded_parent = try? JSONEncoder().encode(self.parent) {
            UserDefaults.standard.set(encoded_parent, forKey: "saved_parent")
        }
    }
    
    func save_all_options() {
        if let encoded_all_options = try? PropertyListEncoder().encode(self.allOptions) {
            UserDefaults.standard.set(encoded_all_options, forKey: "saved_all")
        }
    }
    
    func prevOptions() {
        if (self.parent != 0) {
            self.options = allOptions[self.parent]!.siblings
            self.parent = allOptions[self.options[0]]!.parent
            save_options()
            save_parent()
        }
    }
    
    func clickSelectedBtn() {
        if (self.timer == nil) {
            return
        }
        self.stopTimer()
        self.timer = nil
        let selectedBtn = self.allOptions[self.options[self.selectedBtn]]!
        selectedBtn.selected = true
        self.confirmSelected = true
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
            selectedBtn.selected = false
            if (selectedBtn.isFolder) {
                // folder
                self.parent = self.options[self.selectedBtn]
                self.options = self.allOptions[self.parent]!.children
                self.selectedBtn = 0
            }
            else {
                // not folder
                print(selectedBtn.text)
            }
            self.confirmSelected = false
            self.startTimer()
        }
    }
}
