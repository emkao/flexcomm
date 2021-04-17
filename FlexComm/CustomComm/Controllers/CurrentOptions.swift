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
    
    @Published var parent: Int //{
//        didSet {
//            save_all_options()
//        }
//    }
    @Published var options = [Int]()// {
//        didSet {
//            save_all_options()
//        }
//    }
    @Published var selectedBtn: Int = 0
    @Published var confirmSelected: Bool = false
    var timer: Timer?
    var allOptions: [Int: ButtonOption] = [:] // {
//        didSet {
//            save_all_options()
//        }
//    }
    
    init() {
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
        save_all_options()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingOptions.self)
        try container.encode(self.allOptions, forKey: .allOptions)
    }
    
    required init(from decoder: Decoder) throws {
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
        save_all_options()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: GlobalVars_Unifier.time_unifier, repeats: true) {_ in
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
            print("adding")
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
//            save_options()
            print("finished adding")
        }
    }
    
    func deleteOption(removeIndices: [Int]) {
        print("deleting")
        allOptions[self.parent]!.removeChildren(allOptions: allOptions, removeIndices: removeIndices)
        self.options = allOptions[self.parent]!.children
        save_all_options()
//        save_options()
    }
    
    func editOption(index: Int, text: String, image: UIImage, isFolder: Bool) {
        print("editing")
        let btn = allOptions[allOptions[self.parent]!.children[index]]!
        btn.text = text
        btn.image = CustomImage(withImage: image, withSystem: false)
        btn.isFolder = isFolder
        if (!isFolder) {
            btn.children = []
        }
        self.options = allOptions[self.parent]!.children
        save_all_options()
//        save_options()
    }
    
    func save_all_options() {
        if let encoded_all_options = try? PropertyListEncoder().encode(self.allOptions) {
            UserDefaults.standard.set(encoded_all_options, forKey: "saved_all")
            print("finished saving")
        }
    }
    
    func prevOptions() {
        if (self.parent != 0) { // or isn't null?
            self.options = allOptions[self.parent]!.siblings
            self.parent = allOptions[self.options[0]]!.parent
            save_all_options()
//            save_options()
//            save_parent()
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
