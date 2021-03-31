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
    var parent: Int?
    var isFolder: Bool
    var selected: Bool

    init() {
        self.index = 0
        self.text = ""
        self.image = CustomImage(withImage: UIImage(), withSystem: true)
        self.children = []
        self.siblings = []
        self.isFolder = false
        self.selected = false
    }
    
    init(text: String, isFolder: Bool, index: Int) {
        self.index = index
        self.text = text
        self.image = CustomImage(withImage: UIImage(), withSystem: true)
        self.children = []
        self.siblings = []
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
        self.isFolder = isFolder
        self.selected = false
    }
    
    init(text: String, image: UIImage, isFolder: Bool, index: Int) {
        self.index = index
        self.text = text
        self.image = CustomImage(withImage: image, withSystem: false)
        self.children = []
        self.siblings = []
        self.isFolder = isFolder
        self.selected = false
    }
    
    func addChild(allOptions: [Int:ButtonOption], child: Int) {
        children.append(child)
        allOptions[child]!.parent = self.index
    }
    
    func addChildren(allOptions: [Int:ButtonOption], children: [Int]) {
        for child in children {
            allOptions[child]!.siblings = children
            addChild(allOptions: allOptions, child: child)
        }
    }
    
    func addSibling(sibling: Int) {
        siblings.append(sibling)
    }
    
    func removeChild(allOptions: [Int:ButtonOption], index: Int) {
        for child in children {
            if let idx = allOptions[child]!.siblings.firstIndex(where: {$0 == children[index]} ) {
                allOptions[child]!.siblings.remove(at: idx)
            }
        }
        children.remove(at: index)
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
