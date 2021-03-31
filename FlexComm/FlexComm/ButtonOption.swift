//
//  ButtonOption.swift
//  FlexComm
//
//  Created by emily kao on 3/7/21.
//

import Foundation
import SwiftUI

final class ButtonOption: Codable {
    var index: Int
    var text: String
    var image: CustomImage
    var children: [Int]
    var siblings: [Int]
    var parent: Int
    var isFolder: Bool
    var selected: Bool
    
    private enum CodingOptions: CodingKey {
        case index, text, image, children, siblings, parent, isFolder
    }
 
    init() {
        self.index = 0
        self.text = ""
        self.image = CustomImage(withImage: UIImage(), withSystem: true)
        self.children = []
        self.siblings = []
        self.parent = 0
        self.isFolder = false
        self.selected = false
    }
    
    init(text: String, isFolder: Bool, index: Int) {
        self.index = index
        self.text = text
        self.image = CustomImage(withImage: UIImage(), withSystem: true)
        self.children = []
        self.siblings = []
        self.parent = 0
        self.isFolder = isFolder
        self.selected = false
    }
    
    init(text: String, image: String, isFolder: Bool, index: Int) {
        self.index = index
        self.text = text
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: image) ?? UIImage()
            .withRenderingMode(.alwaysTemplate)
            .withConfiguration(config)
            .withTintColor(.white)
        self.image = CustomImage(withImage: image, withSystem: true)
        self.children = []
        self.siblings = []
        self.parent = 0
        self.isFolder = isFolder
        self.selected = false
    }
    
    init(text: String, image: UIImage, isFolder: Bool, index: Int) {
        self.index = index
        self.text = text
        self.image = CustomImage(withImage: image, withSystem: false)
        self.children = []
        self.siblings = []
        self.parent = 0
        self.isFolder = isFolder
        self.selected = false
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingOptions.self)
        self.index = try container.decode(Int.self, forKey: .index)
        self.text = try container.decode(String.self, forKey: .text)
        self.image = try container.decode(CustomImage.self, forKey: .image)
        self.children = try container.decode([Int].self, forKey: .children)
        self.siblings = try container.decode([Int].self, forKey: .siblings)
        self.isFolder = try container.decode(Bool.self, forKey: .isFolder)
        self.selected = false
        self.parent = try container.decode(Int.self, forKey: .parent)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingOptions.self)
        try container.encode(self.index, forKey: .index)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.children, forKey: .children)
        try container.encode(self.siblings, forKey: .siblings)
        try container.encode(self.isFolder, forKey: .isFolder)
        try container.encode(self.parent, forKey: .parent)
    }
    
    func load() {
        if let saved_index = UserDefaults.standard.data(forKey: "index") {
            if let decoded_index = try? JSONDecoder().decode(Int.self, from: saved_index) {
                self.index = decoded_index
            }
        }
        if let saved_text = UserDefaults.standard.data(forKey: "text") {
            if let decoded_text = try? JSONDecoder().decode(String.self, from: saved_text) {
                self.text = decoded_text
            }
        }
        if let saved_image = UserDefaults.standard.data(forKey: "image") {
            if let decoded_image = try? PropertyListDecoder().decode(CustomImage.self, from: saved_image) {
                self.image = decoded_image
            }
        }
        if let saved_children = UserDefaults.standard.data(forKey: "children") {
            if let decoded_children = try? PropertyListDecoder().decode([Int].self, from: saved_children) {
                self.children = decoded_children
            }
        }
        if let saved_siblings = UserDefaults.standard.data(forKey: "siblings") {
            if let decoded_siblings = try? PropertyListDecoder().decode([Int].self, from: saved_siblings) {
                self.siblings = decoded_siblings
            }
        }
        if let saved_folder = UserDefaults.standard.data(forKey: "folder") {
            if let decoded_folder = try? JSONDecoder().decode(Bool.self, from: saved_folder) {
                self.isFolder = decoded_folder
            }
        }
        if let saved_parent = UserDefaults.standard.data(forKey: "parent") {
            if let decoded_parent = try? JSONDecoder().decode(Int.self, from: saved_parent) {
                self.parent = decoded_parent
            }
        }
    }
    
    func save() {
        if let encoded_index = try? JSONEncoder().encode(self.index) {
            UserDefaults.standard.set(encoded_index, forKey: "index")
        }
        if let encoded_text = try? JSONEncoder().encode(self.text) {
            UserDefaults.standard.set(encoded_text, forKey: "text")
        }
        if let encoded_image = try? PropertyListEncoder().encode(self.image) {
            UserDefaults.standard.set(encoded_image, forKey: "image")
        }
        if let encoded_children = try? PropertyListEncoder().encode(self.children) {
            UserDefaults.standard.set(encoded_children, forKey: "children")
        }
        if let encoded_siblings = try? PropertyListEncoder().encode(self.siblings) {
            UserDefaults.standard.set(encoded_siblings, forKey: "siblings")
        }
        if let encoded_folder = try? JSONEncoder().encode(self.isFolder) {
            UserDefaults.standard.set(encoded_folder, forKey: "folder")
        }
        if let encoded_parent = try? JSONEncoder().encode(self.parent) {
            UserDefaults.standard.set(encoded_parent, forKey: "parent")
        }
    }
    
    func addChild(allOptions: [Int:ButtonOption], child: Int) {
        children.append(child)
        allOptions[child]!.parent = self.index
        save()
    }
    
    func addChildren(allOptions: [Int:ButtonOption], children: [Int]) {
        for child in children {
            allOptions[child]!.siblings = children
            addChild(allOptions: allOptions, child: child)
        }
    }
    
    func addSibling(sibling: Int) {
        siblings.append(sibling)
        save()
    }
    
    func removeChild(allOptions: [Int:ButtonOption], index: Int) {
        for child in children {
            if let idx = allOptions[child]!.siblings.firstIndex(where: {$0 == children[index]} ) {
                allOptions[child]!.siblings.remove(at: idx)
            }
        }
        children.remove(at: index)
        save()
    }
    
    func removeChildren(allOptions: [Int:ButtonOption], removeIndices: [Int]) {
        for index in stride(from: removeIndices.count - 1, to: -1, by: -1) {
            removeChild(allOptions: allOptions, index: removeIndices[index])
        }
    }
}

struct CustomImage: Codable {
    var image: UIImage = UIImage()
    var system: Bool
    
    private enum CodingOptions: CodingKey {
        case image, system
    }
    
    init() {
        if let img = UserDefaults.standard.object(forKey: "image") {
            if let decoded_img = try? JSONDecoder().decode(Data.self, from: img as! Data) {
                self.image = UIImage(data: decoded_img) ?? UIImage()
                if let sys = UserDefaults.standard.data(forKey: "system") {
                    if let decoded_system = try? JSONDecoder().decode(Bool.self, from: sys) {
                        self.system = decoded_system
                        return
                    }
                }
            }
        }
        self.image = UIImage()
        self.system = true
    }
    
    init(withImage image: UIImage, withSystem system: Bool) {
        self.image = image
        self.system = system
    }
    
    func getImage() -> UIImage {
        if system {
            let config = UIImage.SymbolConfiguration(pointSize: 24)
            return self.image
                .withRenderingMode(.alwaysTemplate)
                .withConfiguration(config)
                .withTintColor(.white)
        }
        return self.image
    }
    
    public init(from decoder: Decoder) throws {
        let img = try decoder.container(keyedBy: CodingOptions.self)
        if let decoded_img = try? img.decode(Data.self, forKey: .image) {
            self.image = UIImage(data: decoded_img) ?? UIImage()
            if let decoded_sys = try? img.decode(Bool.self, forKey: .system) {
                self.system = decoded_sys
                return
            }
        }
        self.image = UIImage()
        self.system = true
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingOptions.self)
        try container.encode(self.image.pngData(), forKey: .image)
        try container.encode(self.system, forKey: .system)
    }
    
    func save() {
        if let png = self.image.pngData() {
            if let encoded_png = try? JSONEncoder().encode(png) {
                UserDefaults.standard.set(encoded_png, forKey: "image")
            }
        }
        if let system = try? JSONEncoder().encode(self.system) {
            UserDefaults.standard.set(system, forKey: "system")
        }
    }
}
