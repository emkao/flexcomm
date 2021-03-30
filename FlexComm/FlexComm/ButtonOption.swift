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
    
//    private enum CodingOptions: CodingKey {
//        case text, image, children, isFolder
//    }
    
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
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingOptions.self)
//        try container.encode(self.text, forKey: .text)
//        try container.encode(self.image, forKey: .image)
//        try container.encode(self.children, forKey: .children)
////        try container.encode(self.siblings, forKey: .siblings)
////        try container.encode(self.parent, forKey: .parent)
//        try container.encode(self.isFolder, forKey: .isFolder)
//    }
}

struct CustomImage: Codable {
    var image: UIImage = UIImage()
    var system: Bool
    
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
        if let imageData = UserDefaults.standard.object(forKey: "image") as? Data,
           let image = UIImage(data: imageData) {
            self.image = image
            
            let systemData = UserDefaults.standard.objectIsForced(forKey: "system")
            self.system = systemData
        }
        
        self.image = UIImage()
        self.system = true
    }
    
    public func encode(to encoder: Encoder) throws {
        if let png = self.image.pngData() {
            UserDefaults.standard.set(png, forKey: "image")
        }
        UserDefaults.standard.set(self.system, forKey: "system")
        
//        try container.encode(self.parent, forKey: .parent)
    }
}
